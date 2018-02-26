#!/bin/sh
set -ex
. ./common-functions.sh

export DEBIAN_FRONTEND=noninteractive

c_hostname "n1"
#c_apt_list "bionic"
c_apt_list "xenial"
c_nameserver "8.8.8.8"

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl

r_pkg_upgrade
#echo Y | unminimize
i_base
i_extra
i_kernel_odroid_n1_44
c_if_lo
c_if_dhcp "eth0"
#systemctl enable getty@ttyFIQ0
c_fw_utils "/dev/mmcblk1 0x3c000 0x2000 0x200"
c_locale "en_GB.UTF-8" "de_DE.UTF-8"
c_tzone "Europe/Berlin"
c_user "ubuntu"

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl
