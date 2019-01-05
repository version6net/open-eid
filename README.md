# open-eid
Eesti ID-kaardi tarkvara Dockeri konteineris.

Kui omad arvutis linuxit, mis pole Ubuntu/Debian/Mint, siis saad siin oleva Dockeri tõmmise abil kasutada nii DigiDoc klienti kui ka ajatembeldamise utiliiti. Töötab nii mobiil-ID kui ka ID-kaart.

## Kasutamine

```shell
docker run --rm -e DISPLAY -v $HOME/Documents:/home/openeid -v $HOME/.Xauthority:/home/openeid/.Xauthority --net=host -v /dev/bus/usb:/dev/bus/usb --privileged --security-opt seccomp:unconfined v6net/open-eid
```

Parameetrite selgitus:

|                  parameeter                     |                                     selgitus
|-------------------------------------------------|-------------------------------------------------------------------------------
|`-e DISPLAY`                                     | X11 asukoht (VAJALIK)
|`-v $HOME/Documents:/home/openeid`               | dokumendikausta konteinerile ligipääsetavaks. kasutada võib mistahes kataloogi
|`-v $HOME/.Xauthority:/home/openeid/.Xauthority` | ligipääs masina X11-le (VAJALIK)
|`--net=host`                                     | ilma selleta ei saa rakendust näidata (localhost ühendus - VAJALIK)
|`-v /dev/bus/usb:/dev/bus/usb`                   | ligipääs USB kaardilugejale, pole vaja mID jaoks
|`--privileged`                                   | samuti vajalik kaardilugeja jaoks, pole vaja mID jaoks
|`--security-opt seccomp:unconfined`              | alates versioonist 4 ei tööta Qt mingi platform plugin

Kui tead oma ID-kaardi lugeja aadressi (vt `lsusb`), siis pole vaja parameetreid `-v /dev/bus/usb:/dev/bus/usb` ja `--privileged` vaid piisab parameetrist `--device=/dev/bus/usb/<bus>/<dev>`.

Kui kasutad m-ID'd, siis pole neid parameetreid üldse vaja.

Vaikimisi käivitatakse DigiDoc klient `qdigidoc4`. Ajatembeldamise kasutamiseks, lisa parameeter `qdigidoc-tera-gui`

```shell
docker run --rm -e DISPLAY -v $HOME/Douments:/home/openeid -v $HOME/.Xauthority:/home/openeid/.Xauthority --net=host -v /dev/bus/usb:/dev/bus/usb --privileged --security-opt seccomp:unconfined v6net/open-eid qdigidoc-tera-gui
```
Kaardilugeja kasutamisel, sisesta see USB porti enne konteineri käivitamist.

## Dockeri tõmmise tekitamine

Kui soovid ise tõmmise kokku lasta, siis käib see umbes nii (loomulikult ei pea tõmmise nimi olema `test/openeid`):

```shell
git clone https://github.com/version6net/open-eid.git
cd open-eid
docker build -t test/openeid .
```

## Muu info

Dockeri kasutamine on ainuke lihtne viis ID-kaardi töölesaamiseks Linuxites, mida ametlikult ei toetata nagu näiteks opesuse (testitud), redhat/centos või arch. Aga võid seda ka Ubntuga kasutada, et oma masin mittevajalikest pakkidest puhas hoida.

Tegemist on Ubuntu 18.10 tõmmisega, mille peale on paigaldatud ID-kaardi tarkvara [ID.ee lehel](https://id.ee/index.php?id=34228) näidatud viisil (skripti kasutades). Tulevikus võib ka midagi kergekaalulisemat proovida.

Kui keegi välja mõtleb, kuidas `--security-opt seccomp:unconfined` suvandist lahti saada, siis andku teada :-)

Seda konteinetit tuleks kuskilt otsast väiksemaks ka teha. Praegu jääb sinna sisse kogu arenduskeskkond.
