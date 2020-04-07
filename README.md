# Multi-Speaker Tacotron in TensorFlow


## Prerequisites

- [Docker](https://docs.docker.com/install/)
- [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)


## How To Generate Korean datasets

Follow below commands (explain with `son` dataset).

1. Build docker image.

        $ docker build -t tacotron:latest .

2. Start a docker container.

        $ docker run -it --rm -v /home/lim/repo/multi-speaker-tacotron-tensorflow/datasets:/root/datasets --gpus all tacotron:latest /bin/bash

3. To automate an alignment between sounds and texts, prepare `GOOGLE_APPLICATION_CREDENTIALS` to use [Google Speech Recognition API](https://cloud.google.com/speech/). To get credentials, read [this](https://developers.google.com/identity/protocols/application-default-credentials).

        # export GOOGLE_APPLICATION_CREDENTIALS="YOUR-GOOGLE.CREDENTIALS.json"

4. Download the anchor Son Seok-hee dataset.

    Make sure that your working directory is project's root.

        # python -m datasets.son.download

    Finally missing news IDs would be printed or not. If nothing printed, it means all datasets were downloaded successfully without missing news IDs. Otherwise, re-run the command above to try downloading the missing data until they are not printed.

5. Segment all audios on silence.

        # python -m audio.silence --audio_pattern "./datasets/son/audio/*.wav" --method=pydub

6. By using [Google Speech Recognition API](https://cloud.google.com/speech/), we predict sentences for all segmented audios.

        # python -m recognition.google --audio_pattern "./datasets/son/audio/*.*.wav"

7. By comparing original text and recognised text, save `audio<->text` pair information into `./datasets/son/alignment.json`.

        # python -m recognition.alignment --recognition_path "./datasets/son/recognition.json" --score_threshold=0.5

8. Finally, generated numpy files which will be used in training.

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
