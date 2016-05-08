#!/bin/sh
set -ex

curl -sSL https://www.dropbox.com/s/nt7m6qcv88va3xt/CentOS7-rootfs-aarch64.tar.xz?dl=0 | sudo tar --numeric-owner -xpJf - -C rootfs/

sudo cp centos-02.sh ./rootfs
sudo cp centos-03.sh ./rootfs
sudo cp common-functions.sh ./rootfs

sudo mount -o bind /dev ./rootfs/dev
sudo mount -o bind /dev/pts ./rootfs/dev/pts
sudo mount -t sysfs /sys ./rootfs/sys
sudo mount -t proc /proc ./rootfs/proc

sudo LC_ALL=C LANGUAGE=C LANG=C chroot ./rootfs bash /centos-02.sh
sudo rm ./rootfs/centos-02.sh

set +e
sudo umount -lf ./rootfs/dev/pts
sudo umount -lf ./rootfs/sys
sudo umount -lf ./rootfs/dev
sudo umount -lf ./rootfs/proc
