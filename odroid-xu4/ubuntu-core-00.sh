#!/bin/sh

dev=sda

mkdir /tmp/u-boot
curl -sSL https://github.com/hardkernel/u-boot/raw/odroidxu3-v2012.07/sd_fuse/hardkernel/bl1.bin.hardkernel > /tmp/u-boot/bl1.bin.hardkernel
curl -sSL https://github.com/hardkernel/u-boot/raw/odroidxu3-v2012.07/sd_fuse/hardkernel/bl2.bin.hardkernel > /tmp/u-boot/bl2.bin.hardkernel
curl -sSL https://raw.githubusercontent.com/hardkernel/u-boot/odroidxu3-v2012.07/sd_fuse/hardkernel/sd_fusing.sh >/tmp/u-boot/sd_fusing.sh
curl -sSL https://github.com/hardkernel/u-boot/raw/odroidxu3-v2012.07/sd_fuse/hardkernel/tzsw.bin.hardkernel > /tmp/u-boot/tzsw.bin.hardkernel
curl -sSL https://github.com/hardkernel/u-boot/raw/odroidxu3-v2012.07/sd_fuse/hardkernel/u-boot.bin.hardkernel >/tmp/u-boot/u-boot.bin.hardkernel
 
(cd /tmp/u-boot/ ; sudo sh sd_fusing.sh /dev/$dev )
rm -f /tmp/u-boot/bl1.bin.hardkernel /tmp/u-boot/bl2.bin.hardkernel /tmp/u-boot/sd_fusing.sh /tmp/u-boot/tzsw.bin.hardkernel /tmp/u-boot/u-boot.bin.hardkernel
rmdir /tmp/u-boot

sync
/bin/echo -e "o\nn\np\n1\n3072\n\nw\n" | sudo fdisk /dev/$dev
sync
sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U deadbeef-dead-beef-dead-beefdeadbeef /dev/${dev}1 
sudo mount /dev/${dev}1 ./rootfs
