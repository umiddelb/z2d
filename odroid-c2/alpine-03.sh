#!/bin/sh
set -ex

. ./common-functions.sh

c_nameserver 1.1.1.1

echo "\
@edge http://dl-cdn.alpinelinux.org/alpine/edge/main
@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
>> /etc/apk/repositories

apk update && apk upgrade

# setup locale
echo "\
LC_ALL=en_GB.UTF-8
LANG=en_GB.UTF-8
LANGUAGE=en_GB.UTF-8 " \
>> /etc/profile.d/locale.sh

# setup timezone 
apk add tzdata
cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime
echo "Europe/Berlin" > /etc/timezone
apk del tzdata

c_hostname "c2"

echo "UUID=deadbeef-dead-beef-dead-beefdeadbeef /                       ext4     defaults        0 0" > /etc/fstab

apk add busybox-initscripts tar curl xz bc sudo lzo bridge-utils docker dtc iw screen sysfsutils usbutils pciutils wget lsof ntfs-3g gcc

#apk add rcs@testing most@testing uboot-tools@testing
apk add rcs@testing most@testing

i_kernel_odroid_c2_416

echo "\
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet dhcp " \
> /etc/network/interfaces

echo "\
ttyS0::respawn:/sbin/getty -L ttyAML0 115200 vt100 " \
> /etc/inittab

echo "\
ttyAML0" \
>> /etc/securetty

c_fw_utils "/dev/mmcblk0 0xB4000 0x8000"

passwd root
adduser -g '' alpine
addgroup alpine adm
addgroup alpine cdrom
addgroup alpine wheel
addgroup alpine dialout
