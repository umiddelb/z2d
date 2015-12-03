#!/bin/sh

dev=sdb
echo -e "o\nn\np\n1\n2048\n\nw\n" | sudo fdisk /dev/$dev
sync
sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs /dev/${dev}1
sudo mount /dev/${dev}1 ./rootfs
