#!/bin/sh
set -ex
. ./common-functions.sh

export DEBIAN_FRONTEND=noninteractive

c_hostname "c1"
c_apt_list "bionic"
c_nameserver "1.1.1.1"

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl

r_pkg_upgrade
echo Y | unminimize
i_base
i_extra
i_kernel_odroid_c1_310
c_if_netplan "eth0"
netplan apply
c_fw_utils "/dev/mmcblk0 0x80000 0x8000"
c_locale "en_GB.UTF-8" "de_DE.UTF-8"
c_tzone "Europe/Berlin"
c_user "ubuntu"

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl
