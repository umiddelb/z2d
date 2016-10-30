#!/bin/sh
set -ex

. ./common-functions.sh

c_nameserver 8.8.8.8

if [ -f ./etc/fstab ]; then
  mv ./etc/fstab ./etc/fstab.rpmdefault
fi
echo "UUID=deadbeef-dead-beef-dead-beefdeadbeef /                       ext4     defaults        0 0" > ./etc/fstab

i_kernel_pine64

passwd root
adduser -c '' centos
usermod -aG adm,cdrom,wheel,dialout centos
passwd centos
