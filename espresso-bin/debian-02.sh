#!/bin/sh
. ./common-functions.sh

debootstrap/debootstrap --second-stage

c_locale_debian "en_GB.UTF-8" "de_DE.UTF-8"
c_tzone "Europe/Berlin"
c_hostname "ebin"
c_apt_list_debian "stretch"
c_nameserver "8.8.8.8"

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl
export DEBIAN_FRONTEND=noninteractive

r_pkg_upgrade
i_base_debian

# i_extra_debian
apt-get -q=2 -y install screen wireless-tools iw libncurses5-dev cpufrequtils rcs aptitude gcc make bc man-db ntp usbutils pciutils lsof most sysfsutils firmware-realtek

#i_kernel_...
i_kernel_espresso_bin

c_if_lo
c_if_dhcp "lan0"
echo "  pre-up /sbin/ip link set eth0 up" >> /etc/network/interfaces.d/lan0

c_ttyS "ttyMV0"
c_fw_utils "/dev/mtd1 0x0 0x00010000 0x1000 0x10"
c_user "debian"

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl
