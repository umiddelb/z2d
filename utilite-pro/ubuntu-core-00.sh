#!/bin/sh

dev=mmcblk0
/bin/echo -e "o\nn\np\n1\n2048\n\nw\n" | sudo fdisk /dev/$dev
sync
sudo mkfs.ext4 -O ^has_journal -b 4096 -U deadbeef-dead-beef-dead-beefdeadbeef -L rootfs /dev/${dev}p1
sudo mount /dev/${dev}p1 ./rootfs
