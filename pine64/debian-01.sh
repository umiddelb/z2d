#!/bin/sh

sudo apt-get install qemu qemu-user-static binfmt-support debootstrap

sudo echo ':qemu-arm64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:/qemu-arm64:OC' > /etc/binfmt.d/qemu-arm64.conf
sudo service systemd-binfmt restart

sudo debootstrap --foreign --arch=arm64 --include=vim,locales,dialog,apt jessie rootfs http://ftp.de.debian.org/debian
sudo cp /usr/bin/qemu-aarch64-static rootfs/qemu-arm64

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
