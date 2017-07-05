#!/bin/sh
set -ex

. ./common-functions.sh

yum install -y ntp ntpdate
chkconfig ntpd on
ntpdate pool.ntp.org

timedatectl set-timezone Europe/Berlin
localectl set-locale LANG=en_GB.UTF-8
hostnamectl set-hostname xu4 --static
hostnamectl set-hostname "ODROID-XU4" --pretty

c_yum_list_epel_armhf
c_yum_list_f25_prim
i_base_centos

#c_docker_centos

c_fw_utils "/dev/mmcblk0 0x99E00 0x4000"
