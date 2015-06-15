#!/bin/sh

dev=sda
curl -sSL https://raw.githubusercontent.com/mdrjr/c1_uboot_binaries/master/bl1.bin.hardkernel > /tmp/bl1.bin.hardkernel
curl -sSL https://raw.githubusercontent.com/mdrjr/c1_uboot_binaries/master/u-boot.bin > /tmp/u-boot.bin

sudo dd if=/tmp/bl1.bin.hardkernel of=/dev/$dev bs=1 count=442
sudo dd if=/tmp/bl1.bin.hardkernel of=/dev/$dev bs=512 skip=1 seek=1
sudo dd if=/tmp/u-boot.bin of=/dev/$dev bs=512 seek=64
rm -f /tmp/bl1.bin.hardkernel /tmp/u-boot.bin
sync
/bin/echo -e "o\nn\np\n1\n3072\n262143\nn\np\n2\n262144\n\nt\n1\nb\nw\n" | sudo fdisk /dev/$dev
sync
sudo mkfs.vfat -n boot /dev/${dev}1 
sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U e139ce78-9841-40fe-8823-96a304a09859 /dev/${dev}2 
sudo mount /dev/${dev}2 ./rootfs
sudo mkdir -p ./rootfs/media/boot
sudo mount /dev/${dev}1 ./rootfs/media/boot
