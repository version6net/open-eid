#!/bin/bash

set -e

if [ "${1:0:1}" = '-' ]; then
	set -- bash "$@"
fi

sudo pcscd

if [ "$1" == "" ]; then
	exec qdigidoc4
fi

exec "$@"
