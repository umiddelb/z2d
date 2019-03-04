#!/bin/sh
set -ex
. ./common-functions.sh

export DEBIAN_FRONTEND=noninteractive

c_hostname "n2"
c_apt_list "bionic"
c_nameserver "1.1.1.1"

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl

r_pkg_upgrade
echo Y | unminimize
i_base
i_extra
i_kernel_odroid_n2_49
c_if_netplan "eth0"
netplan apply
c_fw_utils "/dev/mmcblk0 0x000F0000 0x00010000 0x200"
c_locale "en_GB.UTF-8" "de_DE.UTF-8"
c_tzone "Europe/Berlin"
c_user "ubuntu"

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl
