
FROM tensorflow/tensorflow:2.8.2-gpu

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone



RUN apt-get update \
    && apt-get install -y \
        python3.8 \
        python3-pip \
        python3-setuptools \
        pkg-config \
        build-essential \
        git \
        cmake \
        wget \
    && apt-get clean -qq && rm -rf /var/lib/apt/lists/*

RUN mkdir -p protnlm

RUN wget -nc https://storage.googleapis.com/brain-genomics-public/research/proteins/protnlm/uniprot_2022_04/savedmodel__20221011__030822_1128_bs1.bm10.eos_cpu/saved_model.pb -P protnlm -q
RUN mkdir -p protnlm/variables
RUN wget -nc https://storage.googleapis.com/brain-genomics-public/research/proteins/protnlm/uniprot_2022_04/savedmodel__20221011__030822_1128_bs1.bm10.eos_cpu/variables/variables.index -P protnlm/variables/ -q
RUN wget -nc https://storage.googleapis.com/brain-genomics-public/research/proteins/protnlm/uniprot_2022_04/savedmodel__20221011__030822_1128_bs1.bm10.eos_cpu/variables/variables.data-00000-of-00001 -P protnlm/variables/ -q



COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt



RUN mkdir ~/.aws/
RUN mkdir data/
COPY CREDENTIALS_KEY /root/.aws/credentials
COPY server.py server.py
ENTRYPOINT [ "uvicorn", "--host", "0.0.0.0", "--port", "8102","--workers", "4", "server:app"]
