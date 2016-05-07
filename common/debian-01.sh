#!/bin/bash
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
sudo cp system-settings.sh ./rootfs
sudo cp debian-docker-00.sh ./rootfs

sudo LC_ALL=C LANGUAGE=C LANG=C chroot ./rootfs bash /debian-02.sh
sudo rm ./rootfs/debian-02.sh
sudo rm ./rootfs/common-functions.sh

set +e
sudo umount -lf ./rootfs/dev/pts
sudo umount -lf ./rootfs/sys
sudo umount -lf ./rootfs/dev
sudo umount -lf ./rootfs/proc
sudo umount ./rootfs
