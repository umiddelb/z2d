#!/bin/sh
. ./common-functions.sh

debootstrap/debootstrap --second-stage

c_locale_debian "en_GB.UTF-8" "de_DE.UTF-8"
c_tzone "Europe/Berlin"
c_hostname "cbxi"
c_apt_list_debian "stretch"
c_nameserver "8.8.8.8"

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl
export DEBIAN_FRONTEND=noninteractive

r_pkg_upgrade

i_base_debian
#i_extra
apt-get -q=2 -y install dialog screen wireless-tools iw libncurses5-dev cpufrequtils rcs aptitude gcc make bc lzop man-db ntp usbutils pciutils lsof most sysfsutils

i_kernel_cubox_i

c_if_lo
c_if_dhcp "eth0"
c_ttyS_debian "ttymxc0"
c_fw_utils "/dev/mmcblk0 0x60000 0x2000 0x2000"
c_user "debian"

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl
