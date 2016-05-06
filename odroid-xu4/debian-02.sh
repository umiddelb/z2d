#!/bin/sh
. ./common-functions.sh
. ./system-settings.sh

debootstrap/debootstrap --second-stage

c_locale_debian $LOCALES
c_tzone $TIMEZONE
c_hostname $C2_HOSTNAME
c_apt_list_debian "jessie"
c_nameserver $NAMESERVERS

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl
export DEBIAN_FRONTEND=noninteractive

r_pkg_upgrade

i_base_debian
i_extra
i_gcc_debian
i_kernel_odroid_xu4_460

c_if_lo
c_if_dhcp "eth0"
c_ttyS_debian "ttySAC2"
c_fw_utils "/dev/mmcblk0 0x99E00 0x4000"
c_user $USERNAME

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl
