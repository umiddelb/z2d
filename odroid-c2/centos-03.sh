#!/bin/bash
set -ex

. ./common-functions.sh

timedatectl set-timezone Europe/Berlin
localectl set-locale LANG=en_GB.UTF-8
hostnamectl set-hostname c2 --static
hostnamectl set-hostname "ODROID-C2" --pretty

yum update -y
yum install -y bc bridge-utils docker dtc iw lzop rcs screen sysfsutils usbutils wget
c_yum_list_f23_second
yum install -y gcc --enablerepo=warning:fedora23
c_yum_list_f24_second
yum install -y most ntfs-3g uboot-tools --enablerepo=warning:fedora24
yum clean all

mv /etc/fw_env.config /etc/fw_env.config.rpmdefault
c_fw_utils "/dev/mmcblk0 0xB4000 0x8000"
