#!/bin/sh
set -ex

. ./common-functions.sh

c_nameserver 1.1.1.1

echo "UUID=deadbeef-dead-beef-dead-beefdeadbeef /                       ext4     defaults        0 0" > /etc/fstab

i_kernel_odroid_n2_49

c_fw_utils "/dev/mmcblk0 0x000F0000 0x00010000 0x200"

passwd root
adduser -c '' fedora
usermod -aG adm,cdrom,wheel,dialout fedora
passwd fedora

