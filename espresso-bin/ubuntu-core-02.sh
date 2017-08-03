#!/bin/sh
set -ex
. ./common-functions.sh

export DEBIAN_FRONTEND=noninteractive

c_locale "en_GB.UTF-8" "de_DE.UTF-8"
c_tzone "Europe/Berlin"
c_hostname "ebin"
c_apt_list "xenial"
c_nameserver "8.8.8.8"

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl

r_pkg_upgrade
i_base
i_extra
i_kernel_espresso_bin
c_if_lo
c_if_dhcp "lan0"
echo "  pre-up /sbin/ip link set eth0 up" >> /etc/network/interfaces.d/lan0
c_ttyS "ttyMV0"
c_fw_utils "/dev/mtd1 0x0 0x00010000 0x1000 0x10"
c_user "ubuntu"

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl
