FROM ubuntu:22.04
MAINTAINER cougar@random.ee

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get upgrade --yes && \
    apt-get install --no-install-recommends --yes ca-certificates curl gpg locales sudo tzdata && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 openeid && \
    useradd -u 1000 -g 1000 -m openeid && \
    echo "openeid ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    localedef -i et_EE -c -f UTF-8 -A /usr/share/locale/locale.alias et_EE.UTF-8 && \
    ln -sf /usr/share/zoneinfo/Europe/Tallinn /etc/localtime

ENV LANG et_EE.UTF-8
ENV TZ Europe/Tallinn

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

USER 1000:1000
WORKDIR /home/openeid

RUN curl -s https://installer.id.ee/media/install-scripts/install-open-eid.sh \
    | sed 's/^\(distro\)=.*/\1=ubuntu/; s/^\(release\)=.*/\1=22.04/; s/^\(codename\)=.*/\1=jammy/; s/lsb_release/true/' \
    | sed 's/sudo apt-get install/sudo apt-get install -y/' \
    | sed 's/read -p.*/policy=y/' \
    | bash -x -s \
    && sudo rm -rf /var/lib/apt/lists/*
