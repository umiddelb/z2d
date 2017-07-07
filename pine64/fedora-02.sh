#!/bin/sh
set -ex

. ./common-functions.sh

c_nameserver 8.8.8.8

echo "UUID=deadbeef-dead-beef-dead-beefdeadbeef /                       ext4     defaults        0 0" > /etc/fstab

i_base_fedora

i_kernel_pine64

c_fw_utils "/dev/mmcblk0 0x88000 0x20000"

passwd root
adduser -c '' fedora
usermod -aG adm,cdrom,wheel,dialout fedora
passwd fedora
