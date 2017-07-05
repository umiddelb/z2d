#!/bin/sh
. ./common-functions.sh

debootstrap/debootstrap --second-stage

echo \
'deb http://auto.mirror.devuan.org/merged jessie main
deb http://auto.mirror.devuan.org/merged jessie-updates main
deb http://auto.mirror.devuan.org/merged jessie-security main
deb http://auto.mirror.devuan.org/merged jessie-backports main' \
 > /etc/apt/sources.list


c_locale_debian "en_GB.UTF-8" "de_DE.UTF-8"
c_tzone "Europe/Berlin"
c_hostname "upro"
c_nameserver "8.8.8.8"

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl
export DEBIAN_FRONTEND=noninteractive

r_pkg_upgrade
i_base_debian

# i_extra_debian
apt-get -q=2 -y install screen wireless-tools iw libncurses5-dev cpufrequtils rcs aptitude make bc man-db ntp usbutils pciutils lsof most sysfsutils curl xz-utils sudo

i_kernel_utilite_pro

c_if_lo
c_if_dhcp "eth0"
c_ttyS_debian "ttymxc3"
c_fw_utils "/dev/mtd1  0x0  0x2000  0x2000"
c_user "debian"

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl

