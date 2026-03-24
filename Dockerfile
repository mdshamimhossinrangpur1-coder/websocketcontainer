FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -qq \
    && apt install -y -qq curl bash ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://raw.githubusercontent.com/kunshakolime/srtunnel/main/installer.sh | bash
COPY config.yaml /root/srtunnel/config.yaml

CMD ["/root/srtunnel/websocket"]
