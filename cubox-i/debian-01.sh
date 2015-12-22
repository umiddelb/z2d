#!/bin/sh

sudo debootstrap --foreign --include=vim,locales,dialog,apt jessie rootfs http://ftp.de.debian.org/debian


sudo mount -o bind /dev ./rootfs/dev
sudo mount -o bind /dev/pts ./rootfs/dev/pts
sudo mount -t sysfs /sys ./rootfs/sys
sudo mount -t proc /proc ./rootfs/proc
sudo cp /proc/mounts ./rootfs/etc/mtab
sudo cp debian-02.sh ./rootfs
sudo cp common-functions.sh ./rootfs
sudo cp debian-docker-00.sh ./rootfs

sudo LC_ALL=C LANGUAGE=C LANG=C chroot ./rootfs bash /debian-02.sh
sudo rm ./rootfs/debian-02.sh
sudo rm ./rootfs/common-functions.sh

#sudo umount ./rootfs/dev/pts
#sudo umount ./rootfs/sys
#sudo umount -l ./rootfs/dev
#sudo umount -l ./rootfs/proc
