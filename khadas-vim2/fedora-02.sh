#!/bin/sh
set -ex

. ./common-functions.sh

c_nameserver 1.1.1.1

echo "UUID=deadbeef-dead-beef-dead-beefdeadbeef /                       ext4     defaults        0 0" > /etc/fstab

i_kernel_khadas_vim2_419

c_fw_utils "/dev/mmcblk1 0x06c00000 0x10000 0x200"

passwd root
adduser -c '' fedora
usermod -aG adm,cdrom,wheel,dialout fedora
passwd fedora
