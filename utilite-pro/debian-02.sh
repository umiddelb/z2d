#!/bin/bash
. ./common-functions.sh
. ./system-settings.sh

debootstrap/debootstrap --second-stage

c_locale_debian ${LOCALES}
c_tzone ${TIMEZONE}
c_hostname ${UPRO_HOSTNAME}
c_apt_list_debian "jessie"
c_nameserver ${NAMESERVERS}

dpkg-divert --local --rename --add /sbin/initctl; ln -s /bin/true /sbin/initctl
export DEBIAN_FRONTEND=noninteractive

r_pkg_upgrade

i_base_debian
i_extra
i_gcc_debian
i_kernel_utilite_pro

c_if_lo
c_if_dhcp "eth0"
c_ttyS_debian "ttymxc3"
c_fw_utils "/dev/mtd1  0x0  0x2000  0x2000"
c_user ${USERNAME}

apt-get clean

rm /sbin/initctl; dpkg-divert --local --rename --remove /sbin/initctl
