#!/bin/sh
set -ex

dev=sdb
curl -sSL file:///Armbian_5.35_Pine64_U-Boot.bin?raw=true | sudo dd of=/dev/$dev
sync
set +e
/bin/echo -e "o\nn\np\n1\n2048\n\nw\n" | sudo fdisk /dev/$dev
set -e
sync
sudo partprobe -s /dev/$dev

curl -sSL https://github.com/umiddelb/u-571/raw/master/uboot-env > uboot-env
chmod +x uboot-env
sudo ./uboot-env -d /dev/${dev} -o 0x88000 -l 0x20000 del -I
sudo ./uboot-env -d /dev/${dev} -o 0x88000 -l 0x20000 del -i
curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/pine64%2B/bundle.uEnv | sudo ./uboot-env -d /dev/${dev} -o 0x88000 -l 0x20000 set
sync

sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U deadbeef-dead-beef-dead-beefdeadbeef /dev/${dev}1 
sudo mount /dev/${dev}1 ./rootfs
