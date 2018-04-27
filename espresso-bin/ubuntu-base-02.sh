#!/bin/sh
set -ex
. ./common-functions.sh

export DEBIAN_FRONTEND=noninteractive

c_hostname "ebin"
c_apt_list "bionic"
c_nameserver "1.1.1.1"

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl

r_pkg_upgrade
echo Y | unminimize
i_base
i_extra
i_kernel_espresso_bin
c_if_netplan "lan0"
netplan apply
c_fw_utils "/dev/mtd1 0x0 0x00010000 0x1000 0x10"
c_locale "en_GB.UTF-8" "de_DE.UTF-8"
c_tzone "Europe/Berlin"
c_user "ubuntu"

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl
