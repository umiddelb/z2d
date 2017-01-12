#!/bin/sh
set -ex

. ./common-functions.sh

yum install -y ntp ntpdate
chkconfig ntpd on
ntpdate pool.ntp.org

timedatectl set-timezone Europe/Berlin
localectl set-locale LANG=en_GB.UTF-8
hostnamectl set-hostname cbxi --static
hostnamectl set-hostname "SolidRun CuBox-i" --pretty

yum update -y
yum install -y bc bridge-utils dtc iw lzop rcs screen sysfsutils usbutils pciutils wget lsof ntfs-3g
c_yum_list_epel_armhf
c_yum_list_f23_prim
c_yum_list_f24_prim
c_yum_list_f25_prim
#yum install -y gcc docker --enablerepo=warning:fedora23
#yum install -y most ntfs-3g uboot-tools --enablerepo=warning:fedora25
yum clean all

# mv /etc/fw_env.config /etc/fw_env.config.rpmdefault
c_fw_utils "/dev/mmcblk0 0x60000 0x2000 0x2000"
