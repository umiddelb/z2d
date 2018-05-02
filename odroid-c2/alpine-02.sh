#!/bin/sh
set -ex
echo "nameserver 1.1.1.1" >> /etc/resolv.conf
apk update && apk upgrade
apk add bash
bash /alpine-03.sh
