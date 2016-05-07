#!/bin/bash
set -ex
. ./common-functions.sh
. ./system-settings.sh

debootstrap/debootstrap --second-stage

c_locale_debian $LOCALES
c_tzone $TIMEZONE
c_hostname $P64_HOSTNAME
c_apt_list_debian "jessie"
c_nameserver $NAMESERVERS

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl
export DEBIAN_FRONTEND=noninteractive

r_pkg_upgrade
i_base_debian

# curl -sSL http://ftp.debian-ports.org/archive/archive_2015.key | apt-key add -
# echo 'deb http://ftp.debian-ports.org/debian/ unstable main' >> /etc/apt/sources.list.d/ports.list
# echo 'deb http://ftp.debian-ports.org/debian/ unreleased main' >> /etc/apt/sources.list.d/ports.list

apt-get -q=2 -y install screen wireless-tools iw libncurses5-dev cpufrequtils rcs aptitude make bc man-db ntp usbutils pciutils lsof most sysfsutils
i_gcc_debian
i_kernel_pine64

c_if_lo
c_if_dhcp "eth0"
c_ttyS_debian "ttyS0"
c_user $USERNAME

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl
