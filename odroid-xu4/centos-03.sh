#!/bin/sh
set -ex

. ./common-functions.sh

timedatectl set-timezone Europe/Berlin
localectl set-locale LANG=en_GB.UTF-8
hostnamectl set-hostname xu4 --static
hostnamectl set-hostname "ODROID-XU4" --pretty

yum update -y
yum install -y bc bridge-utils docker dtc iw lzop rcs screen sysfsutils usbutils wget
c_yum_list_f23
yum install -y gcc --enablerepo=warning:fedora23
c_yum_list_f24
yum install -y most ntfs-3g uboot-tools --enablerepo=warning:fedora24
yum clean all

usermod -aG docker debian

mv /etc/fw_env.config /etc/fw_env.config.rpmdefault
c_fw_utils "/dev/mmcblk0 0x99E00 0x4000"
