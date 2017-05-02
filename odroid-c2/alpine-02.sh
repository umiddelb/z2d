#!/bin/sh
set -ex
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
apk update && apk upgrade
apk add bash
bash /alpine-03.sh
