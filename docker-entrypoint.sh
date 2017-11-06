#!/bin/bash

set -e

if [ "${1:0:1}" = '-' ]; then
	set -- bash "$@"
fi

sudo pcscd

if [ "$1" == "" ]; then
	exec qdigidocclient
fi

exec "$@"
