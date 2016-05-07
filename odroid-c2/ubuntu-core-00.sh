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

curl -sSL http://dn.odroid.com/S905/BootLoader/ODROID-C2/c2_bootloader.tar.gz | tar -C /tmp -xzf -
sudo dd if=/tmp/c2_bootloader/bl1.bin.hardkernel of=${DEVICE} conv=fsync bs=1 count=442
sudo dd if=/tmp/c2_bootloader/bl1.bin.hardkernel of=${DEVICE} conv=fsync bs=512 skip=1 seek=1
sudo dd if=/tmp/c2_bootloader/u-boot.bin of=${DEVICE} conv=fsync bs=512 seek=97
rm -rf /tmp/c2_bootloader/
sync

curl -sSL https://github.com/umiddelb/u-571/raw/master/uboot-env > uboot-env
chmod +x uboot-env
sudo ./uboot-env -d ${DEVICE} -o 0xB4000 -l 0x8000 del -I
sudo ./uboot-env -d ${DEVICE} -o 0xB4000 -l 0x8000 del -i
curl -sSL https://raw.githubusercontent.com/umiddelb/u-571/master/board/odroid-c2/bundle.uEnv | sudo ./uboot-env -d ${DEVICE} -o 0xB4000 -l 0x8000 set
sync

sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U deadbeef-dead-beef-dead-beefdeadbeef ${DEVICE}${PARTITION_1}
sudo mount ${DEVICE}${PARTITION_1} ./rootfs
