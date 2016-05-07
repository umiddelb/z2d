#!/bin/bash
. ./common-functions.sh
. ./system-settings.sh

debootstrap/debootstrap --second-stage

export DEBIAN_FRONTEND=noninteractive

c_locale $LOCALES
c_tzone $TIMEZONE
c_hostname $C2_HOSTNAME
c_apt_list "xenial"
c_nameserver $NAMESERVERS

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl

apt-get -q=2 update
i_base
i_extra
i_gcc
i_kernel_odroid_c2
c_if_lo
c_if_dhcp "eth0"
c_ttyS "ttyS0"
c_fw_utils "/dev/mmcblk0 0xB4000 0x8000"
c_user $USERNAME

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl
