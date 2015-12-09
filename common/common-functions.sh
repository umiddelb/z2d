#!/bin/sh

c_locale () {
  locale-gen $1
  locale-gen de_DE.UTF-8
  export LC_ALL="$1"
  update-locale LC_ALL="$1" LANG="$1" LC_MESSAGES=POSIX
  dpkg-reconfigure locales
}

c_tzone () {
  echo "$1" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
}


c_hostname () {
  echo $1 > /etc/hostname
  echo "127.0.0.1       $1 localhost" >> /etc/hosts
}

c_apt_list () {
  echo "deb http://ports.ubuntu.com/ ${1} main restricted universe multiverse" > /etc/apt/sources.list
  echo "deb http://ports.ubuntu.com/ ${1}-security main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb http://ports.ubuntu.com/ ${1}-updates main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb http://ports.ubuntu.com/ ${1}-backports main restricted universe multiverse" >> /etc/apt/sources.list
}

c_nameserver () {
  echo "nameserver $1" > /etc/resolv.conf
}

r_pkg_upgrade () {
  apt-get -q=2 update
  apt-get -q=2 -y upgrade
  apt-get -q=2 -y dist-upgrade
}

i_base () {
  apt-get -q=2 -y install software-properties-common u-boot-tools isc-dhcp-client ubuntu-minimal ssh
}

i_extra () {
  apt-get -q=2 -y install cifs-utils screen wireless-tools iw curl libncurses5-dev cpufrequtils rcs aptitude make bc lzop man-db ntp usbutils pciutils lsof most sysfsutils linux-firmware linux-firmware-nonfree
}

i_gcc () {
  apt-get -q=2 -y install python-software-properties
  add-apt-repository -y ppa:ubuntu-toolchain-r/test
  apt-get -q=2 -y update
  apt-get -y install gcc-5 g++-5
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 50
}

i_kernel_odroid_c1 () {
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AB19BAC9
  echo "deb http://deb.odroid.in/c1/ trusty main" > /etc/apt/sources.list.d/odroid.list
  echo "deb http://deb.odroid.in/ trusty main" >> /etc/apt/sources.list.d/odroid.list
  apt-get -q=2 update
  mkdir -p /media/boot
  apt-get -q=2 -y install linux-image-c1 bootini
}

i_kernel_odroid_xu4 () {
  curl -sSL http://deb.odroid.in/5422/pool/main/b/bootini/bootini_20151203-13_armhf.deb >/tmp/bootini_20151203-13_armhf.deb
  curl -sSL http://deb.odroid.in/5422/pool/main/l/linux-headers-xu3/linux-headers-xu3_64-1_armhf.deb >/tmp/linux-headers-xu3_64-1_armhf.deb
  curl -sSL http://deb.odroid.in/umiddelb/linux-image-3.10.92-67_20151123_armhf.deb >/tmp/linux-image-3.10.92-67_20151123_armhf.deb
  dpkg -i /tmp/bootini_20151203-13_armhf.deb /tmp/linux-headers-xu3_64-1_armhf.deb /tmp/linux-image-3.10.92-67_20151123_armhf.deb
  rm -f /tmp/bootini_20151203-13_armhf.deb /tmp/linux-headers-xu3_64-1_armhf.deb /tmp/linux-image-3.10.92-67_20151123_armhf.deb
}

i_kernel_utilite_pro () {
  curl -sSL https://github.com/umiddelb/z2d/raw/master/kernel/linux-3.14.51%2B-upro.tar.xz | unxz | tar --numeric-owner -xpf -
}

i_kernel_cubox_i () {
  curl -sSL http://xilka.com/kernel/3/3.14/3.14.44/release/1/imx-3.14.44-Modules.tar.gz | tar --numeric-owner -xzpf -
  curl -sSL http://xilka.com/kernel/3/3.14/3.14.44/release/1/imx-3.14.44-System.map > /boot/System.map
  curl -sSL http://xilka.com/kernel/3/3.14/3.14.44/release/1/imx-3.14.44-zImage > /boot/zImage
  curl -sSL http://xilka.com/kernel/3/3.14/3.14.44/release/1/imx-3.14.44.config > /boot/config
  curl -sSL http://xilka.com/kernel/3/3.14/3.14.44/release/1/imx6dl-cubox-i-3.14.44.dtb > /boot/imx6dl-cubox-i.dtb
  curl -sSL http://xilka.com/kernel/3/3.14/3.14.44/release/1/imx6dl-hummingboard-3.14.44.dtb > /boot/imx6dl-hummingboard.dtb
  curl -sSL http://xilka.com/kernel/3/3.14/3.14.44/release/1/imx6q-cubox-i-3.14.44.dtb > /boot/imx6q-cubox-i.dtb
  curl -sSL http://xilka.com/kernel/3/3.14/3.14.44/release/1/imx6q-hummingboard-3.14.44.dtb > /boot/imx6q-hummingboard.dtb 
}

c_if_lo () {
  echo "auto lo" > /etc/network/interfaces.d/lo
  echo "iface lo inet loopback" >> /etc/network/interfaces.d/lo
}

c_if_dhcp () {
  echo "auto $1" >/etc/network/interfaces.d/$1
  echo "iface $1 inet dhcp" >>/etc/network/interfaces.d/$1
}

c_ttyS () {
  echo "start on stopped rc or RUNLEVEL=[12345]" > /etc/init/${1}.conf
  echo "stop on runlevel [!12345]" >> /etc/init/${1}.conf
  echo "respawn" >> /etc/init/${1}.conf
  echo "exec /sbin/getty -L 115200 $1 vt102" >> /etc/init/${1}.conf
}

c_user () {
  adduser --gecos '' $1
  usermod -aG adm,cdrom,sudo,plugdev $1
}
