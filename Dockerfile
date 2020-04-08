FROM tensorflow/tensorflow:1.3.0-gpu-py3

ENV PYTHONUNBUFFERED 1

# Install dependencies
COPY requirements.txt /requirements.txt
RUN sed -i "s/archive.ubuntu.com/mirror.kakao.com/g" /etc/apt/sources.list && \
    apt-get update && apt-get upgrade -y && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install -y python3 python3-dev python3-pip ffmpeg git && \
    pip install -U --upgrade pip setuptools wheel
RUN pip install -r /requirements.txt
RUN python -c "import nltk; nltk.download('punkt')"

# Set Korean as default language
RUN apt-get install -y locales && \
    locale-gen ko_KR.UTF-8 && \
    echo "LANG=\"ko_KR.UTF-8\"" >> /etc/default/locale && \
    echo "LC_ALL=\"ko_KR.UTF-8\"" >> /etc/default/locale
ENV LANG ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

COPY . /root
WORKDIR /root