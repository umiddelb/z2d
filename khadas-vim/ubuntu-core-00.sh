#!/bin/sh

dev=mmcblk1

/bin/echo -e "o\nn\np\n1\n3072\n\nw\n" | sudo fdisk /dev/$dev
sync
sudo partprobe -s /dev/$dev

curl -sSL http://dn.odroid.com/S905/BootLoader/ODROID-C2/c2_boot_ubuntu_release.tar.gz | tar -C /tmp -xzf -
sudo dd if=/tmp/c2_boot_ubuntu_release/bl1.bin.hardkernel of=/dev/$dev conv=fsync bs=1 count=442
sudo dd if=/tmp/c2_boot_ubuntu_release/bl1.bin.hardkernel of=/dev/$dev conv=fsync bs=512 skip=1 seek=1
sudo dd if=/tmp/c2_boot_ubuntu_release/u-boot.bin of=/dev/$dev conv=fsync bs=512 seek=97
rm -rf /tmp/c2_boot_ubuntu_release/
sync

curl -sSL https://github.com/umiddelb/u-571/raw/master/uboot-env > uboot-env
chmod +x uboot-env
sudo ./uboot-env -d /dev/${dev} -o 0xB4000 -l 0x8000 del -I
sudo ./uboot-env -d /dev/${dev} -o 0xB4000 -l 0x8000 del -i
curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-c2/bundle.uEnv | sudo ./uboot-env -d /dev/${dev} -o 0xB4000 -l 0x8000 set
sync

sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U deadbeef-dead-beef-dead-beefdeadbeef /dev/${dev}p1 
sudo mount /dev/${dev}p1 ./rootfs
