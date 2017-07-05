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

c_yum_list_epel_armhf
c_yum_list_f25_prim
i_base_centos

# c_docker_centos

c_fw_utils "/dev/mmcblk0 0x60000 0x2000 0x2000"
