#!/bin/sh

dev=mmcblk1
curl -sSL http://dn.odroid.com/S905/BootLoader/ODROID-C2/c2_bootloader.tar.gz | tar -C /tmp -xzvf -

sudo dd if=/tmp/c2_bootloader/bl1.bin.hardkernel of=/dev/$dev conv=fsync bs=1 count=442
sudo dd if=/tmp/c2_bootloader/bl1.bin.hardkernel of=/dev/$dev conv=fsync bs=512 skip=1 seek=1
sudo dd if=/tmp/c2_bootloader/u-boot.bin of=/dev/$dev conv=fsync bs=512 seek=97

rm -rf /tmp/c2_bootloader/
sync
/bin/echo -e "o\nn\np\n1\n3072\n\nw\n" | sudo fdisk /dev/$dev
sync
sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U deadbeef-dead-beef-dead-beefdeadbeef /dev/${dev}p1 
sudo mount /dev/${dev}p1 ./rootfs
