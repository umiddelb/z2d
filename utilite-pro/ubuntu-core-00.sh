#!/bin/bash
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

sudo mkfs.ext4 -O ^has_journal -b 4096 -U deadbeef-dead-beef-dead-beefdeadbeef -L rootfs ${DEVICE}${PARTITION_1}
sudo mount ${DEVICE}${PARTITION_1} ./rootfs
