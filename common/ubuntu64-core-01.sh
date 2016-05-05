#!/bin/sh
set -ex

curl -sSL http://cdimage.ubuntu.com/ubuntu-core/releases/15.10/release/ubuntu-core-15.10-core-arm64.tar.gz | sudo tar --numeric-owner -xpzf - -C rootfs/

sudo mount -o bind /dev ./rootfs/dev
sudo mount -o bind /dev/pts ./rootfs/dev/pts
sudo mount -t sysfs /sys ./rootfs/sys
sudo mount -t proc /proc ./rootfs/proc
sudo cp /proc/mounts ./rootfs/etc/mtab
sudo cp ubuntu-core-02.sh ./rootfs
sudo cp common-functions.sh ./rootfs
sudo cp system-settings.sh ./rootfs
sudo cp ubuntu-docker-00.sh ./rootfs

sudo chroot ./rootfs bash /ubuntu-core-02.sh
sudo rm ./rootfs/ubuntu-core-02.sh
sudo rm ./rootfs/common-functions.sh
sudo rm ./rootfs/system-settings.sh

sudo umount ./rootfs/dev/pts
sudo umount ./rootfs/sys
sudo umount -l ./rootfs/dev
sudo umount -l ./rootfs/proc

