#!/bin/sh
. ./system-settings.sh

re='^[0-9]$'
if  [[ ${DEVICE: -1} =~ $re ]] ; then
    PARTITION_1="p1"
else
    PARTITION_1="1"
fi

/bin/echo -e "o\nn\np\n1\n3072\n\nw\n" | sudo fdisk ${DEVICE}
sync
sudo partprobe -s ${DEVICE}

mkdir /tmp/u-boot
curl -sSL https://github.com/hardkernel/u-boot/raw/odroidxu3-v2012.07/sd_fuse/hardkernel/bl1.bin.hardkernel > /tmp/u-boot/bl1.bin.hardkernel
curl -sSL https://github.com/hardkernel/u-boot/raw/odroidxu3-v2012.07/sd_fuse/hardkernel/bl2.bin.hardkernel > /tmp/u-boot/bl2.bin.hardkernel
curl -sSL https://raw.githubusercontent.com/hardkernel/u-boot/odroidxu3-v2012.07/sd_fuse/hardkernel/sd_fusing.sh >/tmp/u-boot/sd_fusing.sh
curl -sSL https://github.com/hardkernel/u-boot/raw/odroidxu3-v2012.07/sd_fuse/hardkernel/tzsw.bin.hardkernel > /tmp/u-boot/tzsw.bin.hardkernel
curl -sSL https://github.com/hardkernel/u-boot/raw/odroidxu3-v2012.07/sd_fuse/hardkernel/u-boot.bin.hardkernel >/tmp/u-boot/u-boot.bin.hardkernel
(cd /tmp/u-boot/ ; sudo sh sd_fusing.sh ${DEVICE} )
rm -f /tmp/u-boot/bl1.bin.hardkernel /tmp/u-boot/bl2.bin.hardkernel /tmp/u-boot/sd_fusing.sh /tmp/u-boot/tzsw.bin.hardkernel /tmp/u-boot/u-boot.bin.hardkernel
rmdir /tmp/u-boot

curl -sSL https://github.com/umiddelb/u-571/raw/master/uboot-env > uboot-env
chmod +x uboot-env
sudo ./uboot-env -d ${DEVICE} -o 0x99E00 -l 0x4000 del -I
sudo ./uboot-env -d ${DEVICE} -o 0x99E00 -l 0x4000 del -i
curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-xu4/bundle.uEnv | sudo ./uboot-env -d ${DEVICE} -o 0x99E00 -l 0x4000 set
sync

sync
sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U deadbeef-dead-beef-dead-beefdeadbeef ${DEVICE}${PARTITION_1}
sudo mount ${DEVICE}${PARTITION_1} ./rootfs
