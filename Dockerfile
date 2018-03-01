FROM ubuntu:17.04
MAINTAINER cougar@random.ee

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get install -y apt-utils \
    && apt-get install -y locales \
    && apt-get install -y curl \
    && apt-get install -y sudo \
    && apt-get install -y lsb-release \
    && apt-get install -y apt-transport-https libnss3-tools opensc pcscd libxml2 zlib1g fonts-liberation libgcc1 libldap-2.4-2 libpcsclite1 libqt5core5a libqt5gui5-gles libqt5network5 libqt5printsupport5 libqt5widgets5 libssl1.0.0 libstdc++6 libzip4 \
    && sudo rm -rf /var/lib/apt/lists/*

RUN localedef -i et_EE -c -f UTF-8 -A /usr/share/locale/locale.alias et_EE.UTF-8
ENV LANG et_EE.UTF-8

RUN useradd -m openeid
RUN echo "openeid ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

USER openeid

RUN curl -s https://installer.id.ee/media/install-scripts/install-open-eid.sh | sed 's/sudo apt-get install/sudo apt-get install -y/' | bash -s \
    && sudo rm -rf /var/lib/apt/lists/*

WORKDIR /home/openeid
VOLUME [ "/home/openeid" ]

ENTRYPOINT ["/entrypoint.sh"]
