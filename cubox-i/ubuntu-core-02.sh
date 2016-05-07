#!/bin/bash
set -ex 

. ./common-functions.sh
. ./system-settings.sh

export DEBIAN_FRONTEND=noninteractive

c_locale ${LOCALES}
c_tzone ${TIMEZONE}
c_hostname ${CBXI_HOSTNAME}
c_apt_list "xenial"
c_nameserver ${NAMESERVERS}

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl

r_pkg_upgrade
i_base
i_extra
i_gcc
i_kernel_cubox_i
c_if_lo
c_if_dhcp "eth0"
c_ttyS "ttymxc0"
c_fw_utils "/dev/mmcblk0 0x60000 0x2000 0x2000"
c_user ${USERNAME}

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl
