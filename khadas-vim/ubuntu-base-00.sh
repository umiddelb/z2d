#!/bin/sh

dev=mmcblk0

/bin/echo -e "o\nn\np\n1\n3072\n\nw\n" | sudo fdisk /dev/$dev
sync
sudo partprobe -s /dev/$dev

sudo dd if=u-boot.bin.sd.bin of=/dev/$dev conv=fsync,notrunc bs=1 count=444
sudo dd if=u-boot.bin.sd.bin of=/dev/$dev conv=fsync,notrunc bs=512 skip=1 seek=1

sync

curl -sSL https://github.com/umiddelb/u-571/raw/master/uboot-env > uboot-env
chmod +x uboot-env
sudo ./uboot-env -d /dev/${dev} -o 0x7400000 -l 0x10000 del -I
sudo ./uboot-env -d /dev/${dev} -o 0x7400000 -l 0x10000 del -i
curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/khadas-vim/bundle.uEnv | sudo ./uboot-env -d /dev/${dev} -o 0x7400000 -l 0x10000 set
sync

sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U deadbeef-dead-beef-dead-beefdeadbeef /dev/${dev}p1 
sudo mount /dev/${dev}p1 ./rootfs
