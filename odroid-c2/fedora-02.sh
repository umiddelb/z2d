#!/bin/sh
set -ex

. ./common-functions.sh

c_nameserver 1.1.1.1

echo "UUID=deadbeef-dead-beef-dead-beefdeadbeef /                       ext4     defaults        0 0" > /etc/fstab

i_kernel_odroid_c2_419

c_fw_utils "/dev/mmcblk0 0xB4000 0x8000"

passwd root
adduser -c '' fedora
usermod -aG adm,cdrom,wheel,dialout fedora
passwd fedora
