#!/bin/sh

dev=mmcblk1

/bin/echo -e "o\nn\np\n1\n3072\n\nw\n" | sudo fdisk /dev/${dev}
sync
sudo partprobe -s /dev/${dev}

curl -sSL https://raw.githubusercontent.com/mdrjr/c1_uboot_binaries/master/bl1.bin.hardkernel > /tmp/bl1.bin.hardkernel
curl -sSL https://raw.githubusercontent.com/mdrjr/c1_uboot_binaries/master/u-boot.bin > /tmp/u-boot.bin
sudo dd if=/tmp/bl1.bin.hardkernel of=/dev/$dev bs=1 count=442
sudo dd if=/tmp/bl1.bin.hardkernel of=/dev/$dev bs=512 skip=1 seek=1
sudo dd if=/tmp/u-boot.bin of=/dev/$dev bs=512 seek=64
rm -f /tmp/bl1.bin.hardkernel /tmp/u-boot.bin
sync

curl -sSL https://github.com/umiddelb/u-571/raw/master/uboot-env > uboot-env
chmod +x uboot-env
sudo ./uboot-env -d /dev/${dev} -o 0x80000 -l 0x8000 del -I
sudo ./uboot-env -d /dev/${dev} -o 0x80000 -l 0x8000 del -i
curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-c1/bundle.uEnv | sudo ./uboot-env -d /dev/${dev} -o 0x80000 -l 0x8000 set
sync

sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U deadbeef-dead-beef-dead-beefdeadbeef /dev/${dev}p1 
sudo mount /dev/${dev}p1 ./rootfs
