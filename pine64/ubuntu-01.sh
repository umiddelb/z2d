#!/bin/sh

sudo apt-get install qemu qemu-user-static binfmt-support debootstrap

echo ':qemu-arm64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:/qemu-arm64:OC' | sudo dd of=/etc/binfmt.d/qemu-arm64.conf

sudo service systemd-binfmt restart

sudo debootstrap --foreign --include=vim,dialog,apt --variant=minbase --arch=arm64 trusty rootfs http://ports.ubuntu.com/
sudo cp /usr/bin/qemu-aarch64-static rootfs/qemu-arm64


sudo mount -o bind /dev ./rootfs/dev
sudo mount -o bind /dev/pts ./rootfs/dev/pts
sudo mount -t sysfs /sys ./rootfs/sys
sudo mount -t proc /proc ./rootfs/proc
sudo cp /proc/mounts ./rootfs/etc/mtab
sudo cp ubuntu-02.sh ./rootfs
sudo cp common-functions.sh ./rootfs
sudo cp ubuntu-docker-00.sh ./rootfs

sudo chroot ./rootfs sh /ubuntu-02.sh
sudo rm ./rootfs/ubuntu-02.sh
sudo rm ./rootfs/common-functions.sh

sudo umount ./rootfs/dev/pts
sudo umount ./rootfs/sys
sudo umount -l ./rootfs/dev
sudo umount -l ./rootfs/proc
