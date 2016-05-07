#!/bin/bash
set -ex

. ./common-functions.sh

c_nameserver 8.8.8.8

mv /etc/fstab /etc/fstab.rpmdefault
echo "UUID=deadbeef-dead-beef-dead-beefdeadbeef /                       ext4     defaults        0 0" > /etc/fstab

i_kernel_odroid_xu4_460

passwd root
adduser -c '' centos
usermod -aG adm,cdrom,wheel,dialout centos
passwd centos
