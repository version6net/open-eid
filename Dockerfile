FROM ubuntu:18.04
MAINTAINER cougar@random.ee
RUN apt-get update && apt-get install curl sudo lsb-release gnupg pcscd -y 
RUN useradd -m openeid
RUN echo "openeid ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

USER openeid

RUN curl -s https://installer.id.ee/media/install-scripts/install-open-eid.sh | sed 's/sudo apt-get install/sudo apt-get install -y/' | bash -s \
    && sudo rm -rf /var/lib/apt/lists/* \
    && sudo apt-get remove --purge apt-transport-https \
    && sudo apt-get autoremove && sudo apt-get clean
WORKDIR /home/openeid
VOLUME [ "/home/openeid" ]
ENTRYPOINT ["/entrypoint.sh"]
