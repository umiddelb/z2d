#!/bin/sh

dev=mmcblk1
curl -sSL https://raw.githubusercontent.com/mdrjr/c1_uboot_binaries/master/bl1.bin.hardkernel > /tmp/bl1.bin.hardkernel
curl -sSL https://raw.githubusercontent.com/mdrjr/c1_uboot_binaries/master/u-boot.bin > /tmp/u-boot.bin

sudo dd if=/tmp/bl1.bin.hardkernel of=/dev/$dev bs=1 count=442
sudo dd if=/tmp/bl1.bin.hardkernel of=/dev/$dev bs=512 skip=1 seek=1
sudo dd if=/tmp/u-boot.bin of=/dev/$dev bs=512 seek=64
rm -f /tmp/bl1.bin.hardkernel /tmp/u-boot.bin
sync
/bin/echo -e "o\nn\np\n1\n3072\n\nw\n" | sudo fdisk /dev/$dev
sync
sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U e139ce78-9841-40fe-8823-96a304a09859 /dev/${dev}p1 
sudo mount /dev/${dev}p1 ./rootfs
