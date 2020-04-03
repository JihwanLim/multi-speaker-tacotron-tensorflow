# Multi-Speaker Tacotron in TensorFlow


## Prerequisites

- Python 3.6+
- FFmpeg
- [TensorFlow 1.15](https://www.tensorflow.org/install/)


## How To Generate Korean datasets

Follow below commands (explain with `son` dataset).

1. Install prerequisites.

    After preparing [TensorFlow 1.15](https://www.tensorflow.org/install/), install prerequisites with:

        $ pip install -r requirements.txt
        $ python -c "import nltk; nltk.download('punkt')"

2. Download the anchor Son Seok-hee dataset.

    Make sure that your working directory is project's root.

        $ python -m datasets.son.download

3. Set system environment variable to access your Google application credentials.

    To automate an alignment between sounds and texts, prepare `GOOGLE_APPLICATION_CREDENTIALS` to use [Google Speech Recognition API](https://cloud.google.com/speech/). To get credentials, read [this](https://developers.google.com/identity/protocols/application-default-credentials).

        $ export GOOGLE_APPLICATION_CREDENTIALS="YOUR-GOOGLE.CREDENTIALS.json"

4. Segment all audio on silence.

        $ python -m audio.silence --audio_pattern "./datasets/son/audio/*.wav" --method=pydub

5. By comparing original text and recognised text, save `audio<->text` pair information into `./datasets/son/alignment.json`.

        $ python3 -m recognition.alignment --recognition_path "./datasets/son/recognition.json" --score_threshold=0.5

6. Finally, generated numpy files which will be used in training.

        $ python3 -m datasets.generate_data ./datasets/son/alignment.json

Because the automatic generation is extremely naive, the dataset is noisy. However, if you have enough datasets (20+ hours with random initialization or 5+ hours with pretrained model initialization), you can expect an acceptable quality of audio synthesis.


## Disclaimer

This project is not responsible for misuse or for any damage that you may cause. You agree that you use this software at your own risk.


## References

- [Keith Ito](https://github.com/keithito)'s [tacotron](https://github.com/keithito/tacotron)
- [DEVIEW 2017 presentation](https://www.slideshare.net/carpedm20/deview-2017-80824162)
- Taehoon Kim / [@carpedm20](http://carpedm20.github.io/)


## Author

- Jihwan Lim
