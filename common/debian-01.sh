#!/bin/sh
set -ex

sudo apt-get install debootstrap

sudo debootstrap --foreign --include=vim,locales,dialog,apt jessie rootfs http://ftp.debian.org/debian

sudo mount -o bind /dev ./rootfs/dev
sudo mount -o bind /dev/pts ./rootfs/dev/pts
sudo mount -o bind /sys ./rootfs/sys
sudo mount -o bind /proc ./rootfs/proc
sudo cp /proc/mounts ./rootfs/etc/mtab
sudo cp debian-02.sh ./rootfs
sudo cp common-functions.sh ./rootfs
sudo cp debian-docker-00.sh ./rootfs

sudo LC_ALL=C LANGUAGE=C LANG=C chroot ./rootfs bash /debian-02.sh
sudo rm ./rootfs/debian-02.sh
sudo rm ./rootfs/common-functions.sh

sudo umount ./rootfs/dev/pts
sudo umount ./rootfs/sys
sudo umount ./rootfs/dev
sudo umount ./rootfs/proc
sudo umount ./rootfs
