FROM ubuntu:18.04
MAINTAINER cougar@random.ee

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y apt-utils && \
    apt-get install -y locales && \
    apt-get install -y tzdata && \
    apt-get install -y curl && \
    apt-get install -y sudo && \
    apt-get install -y lsb && \
    apt-get install -y libqt5core5a libqt5gui5 libqt5network5 libqt5widgets5 libqt5printsupport5 libqt5svg5 libqt5widgets5 && \
    apt-get install -y libnss3-tools libxerces-c3.2 libxalan-c111 && \
    apt-get install -y fonts-liberation python-nautilus libzip4 libssl1.0.0 && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 openeid && \
    useradd -u 1000 -g 1000 -m openeid && \
    echo "openeid ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN localedef -i et_EE -c -f UTF-8 -A /usr/share/locale/locale.alias et_EE.UTF-8 && \
    ln -sf /usr/share/zoneinfo/Europe/Tallinn /etc/localtime

ENV LANG et_EE.UTF-8

USER 1000:1000
WORKDIR /home/openeid

RUN curl -s https://installer.id.ee/media/install-scripts/install-open-eid.sh | sed 's/sudo apt-get install/sudo apt-get install -y/' | bash -x -s \
    && sudo rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
