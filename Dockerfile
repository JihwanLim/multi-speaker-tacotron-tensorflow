FROM tensorflow/tensorflow:1.3.0-gpu-py3

ENV PYTHONUNBUFFERED 1

# Set locale
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install dependencies
COPY requirements.txt /requirements.txt
RUN sed -i "s/archive.ubuntu.com/mirror.kakao.com/g" /etc/apt/sources.list && \
    apt-get update && apt-get upgrade -y && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install -y python3 python3-dev python3-pip \
        ffmpeg git fonts-nanum* fontconfig && \
    fc-cache -fv && \
    pip install -U --upgrade pip setuptools wheel
RUN pip install -r /requirements.txt
RUN python -c "import nltk; nltk.download('punkt')"

# Clean messy files
RUN apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

COPY . /root
WORKDIR /root