#!/bin/sh
set -ex
. ./common-functions.sh

export DEBIAN_FRONTEND=noninteractive

c_locale "en_GB.UTF-8" "de_DE.UTF-8"
c_tzone "Europe/Berlin"
c_hostname "kvim"
c_apt_list "xenial"
c_nameserver "8.8.8.8"

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl

r_pkg_upgrade
i_base
i_extra
i_gcc
i_kernel_odroid_kvim_31429
c_if_lo
c_if_dhcp "eth0"
c_ttyS "ttyS0"
c_fw_utils "/dev/mmcblk0 0x7400000 0x10000"
c_user "ubuntu"

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl
