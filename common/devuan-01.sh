#!/bin/sh
set -ex

sudo apt-get install debootstrap

sudo debootstrap --foreign --include=vim,locales,dialog,apt --no-check-gpg jessie rootfs http://auto.mirror.devuan.org/merged

sudo mount -o bind /dev ./rootfs/dev
sudo mount -o bind /dev/pts ./rootfs/dev/pts
sudo mount -o bind /sys ./rootfs/sys
sudo mount -o bind /proc ./rootfs/proc
sudo cp /proc/mounts ./rootfs/etc/mtab
sudo cp devuan-02.sh ./rootfs
sudo cp common-functions.sh ./rootfs

sudo mkdir ./rootfs/etc/apt/trusted.gpg.d
sudo cp devuan-keyring-2016-archive.gpg devuan-keyring-2016-cdimage.gpg ./rootfs/etc/apt/trusted.gpg.d

sudo LC_ALL=C LANGUAGE=C LANG=C chroot ./rootfs bash /devuan-02.sh
sudo rm ./rootfs/devuan-02.sh
sudo rm ./rootfs/common-functions.sh

set +e
sudo umount -lf ./rootfs/dev/pts
sudo umount -lf ./rootfs/sys
sudo umount -lf ./rootfs/dev
sudo umount -lf ./rootfs/proc
