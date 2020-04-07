# Multi-Speaker Tacotron in TensorFlow


## Prerequisites

- [Docker](https://docs.docker.com/install/)
- [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)


## How To Generate Korean datasets

Follow below commands (explain with `son` dataset).

1. To automate an alignment between sounds and texts, prepare `GOOGLE_APPLICATION_CREDENTIALS` to use [Google Speech Recognition API](https://cloud.google.com/speech/). To get credentials, read [this](https://developers.google.com/identity/protocols/application-default-credentials).

    Make sure your credentials are in the project's root.

2. Build docker image.

        $ docker build -t tacotron:latest .

3. Start a docker container.

    Feel free to change `--gpus` option. The option depends on your computer hardware system.

        $ docker run -it --rm -v /path/to/multi-speaker-tacotron-tensorflow/datasets:/root/datasets --gpus '"device=0"' tacotron:latest /bin/bash

4. Set environment variable `GOOGLE_APPLICATION_CREDENTIALS`.

        # export GOOGLE_APPLICATION_CREDENTIALS=/root/your-credentials.json

5. Download the anchor Son Seok-hee dataset.

    Make sure that your working directory is the project's root.

        # python -m datasets.son.download

    When this step is done, the missing news IDs would be finally displayed or not. If nothing displayed, it means all datasets were downloaded successfully without missing news IDs. Otherwise, re-run the command above to retry downloading the missing data until they are not displayed.

    And you also might encounter an issue that your typing doesn't be displayed on your shell. If so press `ctrl`+`c` to exit and restart the container, and then don't forget to export `GOOGLE_APPLICATION_CREDENTIALS`.

6. Segment all audios on silence.

        # python -m audio.silence --audio_pattern "./datasets/son/audio/*.wav" --method=pydub

7. By using [Google Speech Recognition API](https://cloud.google.com/speech/), we predict sentences for all segmented audios.

        # python -m recognition.google --audio_pattern "./datasets/son/audio/*.*.wav"

8. Remove all news IDs that raise errors from `alignment.json`.

    I found the fact that the asset files (.txt) of which the number of rows is only one cause unexpected error during the next step. Honestly I don't know why it causes the error, and I decided I exclude them from the `alignment.json` because it's a tolerable loss enough.

    To see what news IDs will cause errors:

        # wc -l datasets/son/assets/NB*.txt | grep " 0 datasets*" | awk -F '/' '{print($4)}' | awk -F '.' '{print($1)}'

    What the following command does is to get all news IDs that raise errors and to remove all lines including them from `alignment.json`. Make sure that your working directory is the project's root. I also recommend you to backup the JSON file before.

        # cp datasets/son/recognition.json datasets/son/recognition.backup.json
        # for news_id in $(wc -l datasets/son/assets/NB*.txt | grep " 0 datasets*" | awk -F '/' '{print($4)}' | awk -F '.' '{print($1)}'); do sed -i "/$news_id/d" datasets/son/recognition.json; done

    To check if the number of lines of `alignment.json` was decreased:

        # wc -l datasets/son/recognition.json
        49871 datasets/son/recognition.json

        # wc -l datasets/son/recognition.backup.json
        50363 datasets/son/recognition.backup.json

8. By comparing original text and recognised text, save `audio<->text` pair information into `./datasets/son/alignment.json`.

        # python -m recognition.alignment --recognition_path "./datasets/son/recognition.json" --score_threshold=0.5 --recognition_encoding=utf-8

9. Finally, generated numpy files which will be used in training.

        # python -m datasets.generate_data ./datasets/son/alignment.json

Because the automatic generation is extremely naive, the dataset is noisy. However, if you have enough datasets (20+ hours with random initialization or 5+ hours with pretrained model initialization), you can expect an acceptable quality of audio synthesis.


## Disclaimer

This project is not responsible for misuse or for any damage that you may cause. You agree that you use this software at your own risk.


## References

- [Keith Ito](https://github.com/keithito)'s [tacotron](https://github.com/keithito/tacotron)
- [DEVIEW 2017 presentation](https://www.slideshare.net/carpedm20/deview-2017-80824162)
- Taehoon Kim / [@carpedm20](http://carpedm20.github.io/)


## Author

- Jihwan Lim
