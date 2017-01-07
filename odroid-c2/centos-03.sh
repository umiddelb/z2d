#!/bin/sh
set -ex

. ./common-functions.sh

yum install -y ntp ntpdate
chkconfig ntpd on
ntpdate pool.ntp.org

timedatectl set-timezone Europe/Berlin
localectl set-locale LANG=en_GB.UTF-8
hostnamectl set-hostname c2 --static
hostnamectl set-hostname "ODROID-C2" --pretty

yum update -y
yum install -y bc bridge-utils docker dtc iw lzop rcs screen sysfsutils usbutils pciutils wget lsof ntfs-3g
c_yum_list_epel_aarch64
# c_yum_list_f25_second
# yum install -y most uboot-tools --enablerepo=warning:fedora24
yum clean all

# mv /etc/fw_env.config /etc/fw_env.config.rpmdefault
c_fw_utils "/dev/mmcblk0 0xB4000 0x8000"
