FROM debian:12.1-slim

RUN apt-get update && apt-get install -y \
        curl \
    && rm -rf /var/lib/apt/lists/*

ENV RUN_FREQ=10m \
    PING_URL= \
    DF_FILESYSTEMS= \
    DF_HIGHWATERMARK=90

COPY scripts /scripts

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
