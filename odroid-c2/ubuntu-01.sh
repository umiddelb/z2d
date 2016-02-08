#!/bin/sh

sudo debootstrap --foreign --include=vim,dialog,apt --variant=minbase --arch=arm64 xenial rootfs http://ports.ubuntu.com/

sudo mount -o bind /dev ./rootfs/dev
sudo mount -o bind /dev/pts ./rootfs/dev/pts
sudo mount -t sysfs /sys ./rootfs/sys
sudo mount -t proc /proc ./rootfs/proc
sudo cp /proc/mounts ./rootfs/etc/mtab
sudo cp ubuntu-02.sh ./rootfs
sudo cp common-functions.sh ./rootfs
# sudo cp ubuntu-docker-00.sh ./rootfs

sudo chroot ./rootfs bash /ubuntu-02.sh
sudo rm ./rootfs/ubuntu-02.sh
sudo rm ./rootfs/common-functions.sh

sudo umount ./rootfs/dev/pts
sudo umount ./rootfs/sys
sudo umount -l ./rootfs/dev
sudo umount -l ./rootfs/proc
