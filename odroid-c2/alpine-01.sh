#!/bin/sh
set -ex

curl -sSL https://nl.alpinelinux.org/alpine/v3.7/releases/aarch64/alpine-minirootfs-3.7.0-aarch64.tar.gz | sudo tar --numeric-owner -xpihzf - -C rootfs/

sudo chmod 755 ./rootfs
sudo cp alpine-02.sh alpine-03.sh ./rootfs
sudo cp common-functions.sh ./rootfs

sudo mount -o bind /dev ./rootfs/dev
sudo mount -o bind /dev/pts ./rootfs/dev/pts
sudo mount -t sysfs /sys ./rootfs/sys
sudo mount -t proc /proc ./rootfs/proc

# sudo LC_ALL=C LANGUAGE=C LANG=C chroot ./rootfs sh
sudo LC_ALL=C LANGUAGE=C LANG=C chroot ./rootfs sh /alpine-02.sh
sudo rm ./rootfs/alpine-02.sh ./rootfs/alpine-03.sh ./rootfs/common-functions.sh

set +e
sudo umount -lf ./rootfs/dev/pts
sudo umount -lf ./rootfs/sys
sudo umount -lf ./rootfs/dev
sudo umount -lf ./rootfs/proc
