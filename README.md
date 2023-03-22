# open-eid
Eesti ID-kaardi tarkvara Dockeri konteineris.

Kui omad arvutis linuxit, mis pole Ubuntu/Debian/Mint, siis saad siin oleva Dockeri tõmmise abil kasutada nii DigiDoc klienti kui ka ajatembeldamise utiliiti. Töötab nii mobiil-ID kui ka ID-kaart.

## Kasutamine

ID-kaardi kasutamiseks ühenda kaardilugeja enne konteineri käivitamist!

```shell
docker run --rm -e DISPLAY -v $HOME/.docker-root-openeid:/home/openeid -v $HOME/.Xauthority:/home/openeid/.Xauthority -v $HOME/Documents:/home/openeid/Documents --hostname $(uname -n) -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri:/dev/dri --device /dev/bus/usb --init v6net/open-eid
```

Parameetrite selgitus:

|                  parameeter                     |                                     selgitus
|-------------------------------------------------|-------------------------------------------------------------------------------
|`-e DISPLAY`                                     | X11 asukoht (VAJALIK)
|`-v $HOME/.docker-root-openeid:/home/openeid`    | konteineri kasutaja kodukataloog. vajalik seadistuste meeldejätmiseks
|`-v $HOME/.Xauthority:/home/openeid/.Xauthority` | ligipääs masina X11-le (VAJALIK)
|`-v $HOME/Documents:/home/openeid/Documents`     | dokumendikausta konteinerile ligipääsetavaks. kasutada võib mistahes kataloogi
|`--hostname $(uname -n)`                         | annab konteinerile masina nime, et X11 ligipääs töötaks (VAJALIK)
|`-v /tmp/.X11-unix:/tmp/.X11-unix`               | X11 ligipääs (VAJALIK)
|`-v /dev/dri:/dev/dri`                           | otseligipääs graafikakaardile (Direct Rendering Infrastructure)
|`-v /dev/bus/usb:/dev/bus/usb`                   | ligipääs USB kaardilugejale, pole vaja mID jaoks

Kui tead oma ID-kaardi lugeja aadressi (vt `lsusb`), siis pole vaja anda ligipääsu kõigile USB seadmetele võtmega `-v /dev/bus/usb:/dev/bus/usb` vaid piisab parameetrist `--device=/dev/bus/usb/<bus>/<dev>`.

Kui kasutad m-ID'd, siis pole neid parameetreid üldse vaja.

Vaikimisi käivitatakse DigiDoc klient `qdigidoc4`. digidoc-tool kasutamiseks lisa see parameetriks

```shell
docker run -ti --rm -e DISPLAY -v $HOME/.docker-root-openeid:/home/openeid -v $HOME/.Xauthority:/home/openeid/.Xauthority -v $HOME/Documents:/home/openeid/Documents --hostname $(uname -n) -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri:/dev/dri --device /dev/bus/usb --init v6net/open-eid digidoc-tool
```

## Dockeri tõmmise tekitamine

Kui soovid ise tõmmise kokku lasta, siis käib see umbes nii (loomulikult ei pea tõmmise nimi olema `test/openeid`):

```shell
git clone https://github.com/version6net/open-eid.git
cd open-eid
docker build -t test/openeid .
```

## Muu info

Dockeri kasutamine on ainuke lihtne viis ID-kaardi töölesaamiseks Linuxites, mida ametlikult ei toetata nagu näiteks opesuse (testitud), redhat/centos või arch. Aga võid seda ka Ubntuga kasutada, et oma masin mittevajalikest pakkidest puhas hoida.

Tegemist on Ubuntu 20.04 tõmmisega, mille peale on paigaldatud ID-kaardi tarkvara [ID.ee lehel](https://id.ee/index.php?id=34228) näidatud viisil (skripti kasutades). Tulevikus võib ka midagi kergekaalulisemat proovida.

Seda konteinetit tuleks kuskilt otsast väiksemaks ka teha. Praegu jääb sinna sisse kogu arenduskeskkond.
