#!/bin/sh

dev=sdb

/bin/echo -e "o\nn\np\n1\n2048\n\nw\n" | sudo fdisk /dev/$dev
sync
sudo partprobe -s

curl -sSL https://github.com/umiddelb/u-boot-imx6/raw/imx6/bin/SPL | sudo dd of=/dev/$dev bs=1k seek=1
curl -sSL https://github.com/umiddelb/u-boot-imx6/raw/imx6/bin/u-boot.img | sudo dd of=/dev/$dev bs=1k seek=42
sync

sudo mkfs.ext4 -O ^has_journal -b 4096 -U deadbeef-dead-beef-dead-beefdeadbeef -L rootfs /dev/${dev}1
sudo mount /dev/${dev}1 ./rootfs
