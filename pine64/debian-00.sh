#!/bin/sh
set -ex

dev=sdc
curl -sSL https://www.stdin.xyz/downloads/people/longsleep/tmp/pine64-images/simpleimage-pine64-20160221-4.img.xz | unxz | sudo dd of=/dev/$dev
sync
/bin/echo -e "d\n2\nn\np\n2\n143360\n\nw\n" | sudo fdisk /dev/$dev
sync
sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U deadbeef-dead-beef-dead-beefdeadbeef /dev/${dev}2 
sudo mount /dev/${dev}2 ./rootfs
sudo mkdir ./rootfs/boot
sudo mount /dev/${dev}1 ./rootfs/boot
