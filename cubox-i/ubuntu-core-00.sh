#!/bin/sh
. ./system-settings.sh

re='^[0-9]$'
if  [[ ${DEVICE: -1} =~ $re ]] ; then
    PARTITION_1="p1"
else
    PARTITION_1="1"
fi

/bin/echo -e "o\nn\np\n1\n2048\n\nw\n" | sudo fdisk ${DEVICE}
sync
sudo partprobe -s ${DEVICE}

curl -sSL https://github.com/umiddelb/u-boot-imx6/raw/imx6/bin/SPL | sudo dd of=${DEVICE} bs=1k seek=1
curl -sSL https://github.com/umiddelb/u-boot-imx6/raw/imx6/bin/u-boot.img | sudo dd of=${DEVICE} bs=1k seek=42
sync

sudo mkfs.ext4 -O ^has_journal -b 4096 -U deadbeef-dead-beef-dead-beefdeadbeef -L rootfs ${DEVICE}${PARTITION_1}
sudo mount ${DEVICE}${PARTITION_1} ./rootfs
