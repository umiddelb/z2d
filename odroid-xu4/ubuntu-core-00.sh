#!/bin/sh

dev=sda

mkdir /tmp/u-boot
curl -sSL https://github.com/hardkernel/u-boot/blob/odroid-v2010.12/sd_fuse/bl1.HardKernel?raw=true > /tmp/u-boot/bl1.HardKernel
curl -sSL https://github.com/hardkernel/u-boot/blob/odroid-v2010.12/sd_fuse/bl2.HardKernel?raw=true > /tmp/u-boot/bl2.HardKernel
curl -sSL https://raw.githubusercontent.com/hardkernel/u-boot/odroid-v2010.12/sd_fuse/sd_fusing.sh >/tmp/u-boot/sd_fusing.sh
curl -sSL https://github.com/hardkernel/u-boot/blob/odroid-v2010.12/sd_fuse/tzsw.HardKernel?raw=true > /tmp/u-boot/tzsw.HardKernel
curl -sSL https://github.com/hardkernel/u-boot/blob/odroid-v2010.12/sd_fuse/u-boot.bin.HardKernel?raw=true >/tmp/u-boot.bin
 
(cd /tmp/u-boot/ ; sudo sh sd_fusing.sh /dev/$dev )
rm -f /tmp/u-boot/bl1.HardKernel /tmp/u-boot/bl2.HardKernel /tmp/u-boot/sd_fusing.sh /tmp/u-boot/tzsw.HardKernel /tmp/u-boot.bin
rmdir /tmp/u-boot

sync
/bin/echo -e "o\nn\np\n1\n3072\n\nw\n" | sudo fdisk /dev/$dev
sync
sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U e139ce78-9841-40fe-8823-96a304a09859 /dev/${dev}1 
sudo mount /dev/${dev}1 ./rootfs
