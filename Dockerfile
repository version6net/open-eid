FROM ubuntu:22.04
LABEL org.opencontainers.image.authors="cougar@random.ee"

ENV DEBIAN_FRONTEND noninteractive
RUN apt update && \
    apt upgrade --yes && \
    apt install --no-install-recommends --yes ca-certificates curl gpg locales sudo tzdata software-properties-common gpg-agent && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 openeid && \
    useradd -u 1000 -g 1000 -m openeid && \
    echo "openeid ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    localedef -i et_EE -c -f UTF-8 -A /usr/share/locale/locale.alias et_EE.UTF-8 && \
    ln -sf /usr/share/zoneinfo/Europe/Tallinn /etc/localtime && \
    add-apt-repository ppa:mozillateam/ppa -y && \
    echo 'Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001\n' > /etc/apt/preferences.d/mozilla-firefox && \
    echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' > /etc/apt/apt.conf.d/51unattended-upgrades-firefox && \
    apt install -y firefox

ENV LANG et_EE.UTF-8
ENV TZ Europe/Tallinn

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

USER 1000:1000
WORKDIR /home/openeid

RUN curl -s https://installer.id.ee/media/install-scripts/install-open-eid.sh \
    | sed 's/^\(distro\)=.*/\1=ubuntu/; s/^\(release\)=.*/\1=22.04/; s/^\(codename\)=.*/\1=jammy/; s/lsb_release/true/' \
    | sed 's/sudo apt install/sudo apt install -y/' \
    | sed 's/read -p.*/policy=y/' \
    | sed 's/sudo systemctl/# sudo systemctl/' \
    | sed 's/xdg-open/true xdg-open/' \
    | bash -x -s \
    && sudo rm -rf /var/lib/apt/lists/*
