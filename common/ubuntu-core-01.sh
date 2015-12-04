#!/bin/sh

curl -sSL http://cdimage.ubuntu.com/ubuntu-core/releases/14.04.3/release/ubuntu-core-14.04.3-core-armhf.tar.gz | sudo tar --numeric-owner -xpzf - -C rootfs/

sudo mount -o bind /dev ./rootfs/dev
sudo mount -o bind /dev/pts ./rootfs/dev/pts
sudo mount -t sysfs /sys ./rootfs/sys
sudo mount -t proc /proc ./rootfs/proc
sudo cp /proc/mounts ./rootfs/etc/mtab
sudo cp ubuntu-core-02.sh ./rootfs
sudo cp common-functions.sh ./rootfs
sudo cp ubuntu-docker-00.sh ./rootfs

sudo chroot ./rootfs sh /ubuntu-core-02.sh
sudo rm ./rootfs/ubuntu-core-02.sh
sudo rm ./rootfs/common-functions.sh

sudo umount ./rootfs/dev/pts
sudo umount ./rootfs/sys
sudo umount -l ./rootfs/dev
sudo umount -l ./rootfs/proc
