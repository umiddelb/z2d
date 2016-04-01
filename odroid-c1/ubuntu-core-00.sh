#!/bin/sh

dev=mmcblk1
curl -sSL http://dn.odroid.com/S805/Ubuntu/ubuntu-14.04.3lts-lubuntu-odroid-c1-20151020.img.xz | unxz | sudo dd of=/dev/${dev} count=$((3072/2/512)) bs=512k
curl -sSL https://github.com/umiddelb/u-571/raw/master/uboot-env > uboot-env
chmod +x uboot-env
sudo ./uboot-env -d /dev/${dev} -o 0x80000 -l 0x8000 del -I
sudo ./uboot-env -d /dev/${dev} -o 0x80000 -l 0x8000 del -i
curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-c1/bundle.uEnv | sudo ./uboot-env -d /dev/${dev} -o 0x80000 -l 0x8000 set
sync
/bin/echo -e "o\nn\np\n1\n3072\n\nw\n" | sudo fdisk /dev/${dev}
sync
sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U deadbeef-dead-beef-dead-beefdeadbeef /dev/${dev}p1 
sudo mount /dev/${dev}p1 ./rootfs
