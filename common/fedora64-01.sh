#!/bin/sh
set -ex

#curl -sSL http://libguestfs.org/download/builder/fedora-25-aarch64.xz | sudo tar --numeric-owner -xpihJf - -C rootfs/
curl -sSL https://www.dropbox.com/s/rf374x4foeo2dso/Fedora25-rootfs-aarch64.xz?dl=0 | sudo tar --numeric-owner -xpihJf - -C rootfs/

sudo cp fedora-02.sh ./rootfs
sudo cp fedora-03.sh ./rootfs
sudo cp common-functions.sh ./rootfs

sudo mount -o bind /dev ./rootfs/dev
sudo mount -o bind /dev/pts ./rootfs/dev/pts
sudo mount -t sysfs /sys ./rootfs/sys
sudo mount -t proc /proc ./rootfs/proc

sudo LC_ALL=C LANGUAGE=C LANG=C chroot ./rootfs bash /fedora-02.sh
sudo rm ./rootfs/fedora-02.sh

set +e
sudo umount -lf ./rootfs/dev/pts
sudo umount -lf ./rootfs/sys
sudo umount -lf ./rootfs/dev
sudo umount -lf ./rootfs/proc
