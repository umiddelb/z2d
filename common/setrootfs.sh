#!/bin/sh
set -ex
uuid=`sudo blkid $1 | tr ' ' '\n' | grep ^UUID= | tr -d '"'`
sudo sed -i -e "s/UUID=\\w*-\\w*-\\w*-\\w*-\\w*/$uuid/" ./rootfs/boot/conf.d/default/uEnv.txt 
