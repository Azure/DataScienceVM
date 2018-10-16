FROM ubuntu:xenial

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends libcurl4-openssl-dev python-pip libboost-python-dev && \
    rm -rf /var/lib/apt/lists/* 

COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY . .
RUN mkdir /myvol
RUN touch /myvol/data.json
RUN chmod 777 /myvol/data.json
VOLUME /myvol
RUN useradd -ms /bin/bash moduleuser
USER moduleuser

CMD [ "python", "-u", "./main.py" ]