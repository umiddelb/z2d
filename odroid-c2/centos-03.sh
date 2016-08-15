#!/bin/sh
set -ex

. ./common-functions.sh

timedatectl set-timezone Europe/Berlin
localectl set-locale LANG=en_GB.UTF-8
hostnamectl set-hostname c2 --static
hostnamectl set-hostname "ODROID-C2" --pretty

yum update -y
yum install -y ntp bc bridge-utils docker dtc iw lzop rcs screen sysfsutils usbutils pciutils wget lsof ntfs-3g
c_yum_list_epel_aarch64
# yum install -y gcc --enablerepo=warning:fedora23
# yum install -y most uboot-tools --enablerepo=warning:fedora24
yum clean all

# mv /etc/fw_env.config /etc/fw_env.config.rpmdefault
c_fw_utils "/dev/mmcblk0 0xB4000 0x8000"
