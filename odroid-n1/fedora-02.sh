#!/bin/sh
set -ex

. ./common-functions.sh

c_nameserver 1.1.1.1

echo "UUID=deadbeef-dead-beef-dead-beefdeadbeef /                       ext4     defaults        0 0" > /etc/fstab

i_kernel_odroid_n1_44

c_fw_utils "/dev/mmcblk1 0x3c000 0x2000 0x200"

passwd root
adduser -c '' fedora
usermod -aG adm,cdrom,wheel,dialout fedora
passwd fedora
