#!/bin/sh
. ./common-functions.sh
. ./system-settings.sh

export DEBIAN_FRONTEND=noninteractive

c_locale $LOCALES
c_tzone $TIMEZONE
c_hostname $XU4_HOSTNAME
c_apt_list "xenial"
c_nameserver $NAMESERVERS

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl

r_pkg_upgrade
i_base
i_extra
i_gcc
i_kernel_odroid_xu4_460
c_if_lo
c_if_dhcp "eth0"
c_ttyS "ttySAC2"
c_fw_utils "/dev/mmcblk0 0x99E00 0x4000"
c_user $USERNAME

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl
