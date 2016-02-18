#!/bin/sh

c_locale () {
  locale-gen $1
  locale-gen de_DE.UTF-8
  export LC_ALL="$1"
  update-locale LC_ALL="$1" LANG="$1" LC_MESSAGES=POSIX
  dpkg-reconfigure -f noninteractive locales
}

c_locale_debian () {
  echo "$1 UTF-8" > /etc/locale.gen
  echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
  locale-gen
  debconf-set-selections <<< "locales locales/default_environment_locale select $1"
  dpkg-reconfigure -f noninteractive locales
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

c_apt_list_debian () {
  echo "deb http://ftp.debian.org/debian/ ${1} main contrib non-free" > /etc/apt/sources.list
  echo "deb http://ftp.debian.org/debian/ ${1}-updates main contrib non-free" >> /etc/apt/sources.list
  echo "deb http://ftp.debian.org/debian/ ${1}-backports main contrib non-free" >> /etc/apt/sources.list
  echo "deb http://security.debian.org/ ${1}/updates main contrib non-free" >> /etc/apt/sources.list

  echo "APT::Default-Release \"${1}\";" > /etc/apt/apt.conf.d/99defaultrelease

  echo "deb http://ftp.debian.org/debian/ stable main contrib non-free" > /etc/apt/sources.list.d/stable.list
  echo "deb http://security.debian.org/ stable/updates main contrib non-free" >> /etc/apt/sources.list.d/stable.list

  echo "deb http://ftp.debian.org/debian/ testing main contrib non-free" > /etc/apt/sources.list.d/testing.list
  echo "deb http://security.debian.org/ testing/updates main contrib non-free" >> /etc/apt/sources.list.d/testing.list
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
  apt-get -q=2 -y install ubuntu-minimal software-properties-common curl u-boot-tools isc-dhcp-client ubuntu-minimal ssh linux-firmware linux-firmware-nonfree
}

i_base_debian () {
  apt-get -q=2 -y install curl xz-utils u-boot-tools sudo openssh-server ntpdate ntp usbutils pciutils less lsof most sysfsutils ntfs-3g exfat-utils exfat-fuse firmware-linux

}

i_extra () {
  apt-get -q=2 -y install screen wireless-tools iw libncurses5-dev cpufrequtils rcs aptitude make bc lzop man-db ntp usbutils pciutils lsof most sysfsutils
}

i_gcc () {
  apt-get -q=2 -y install python-software-properties
  add-apt-repository -y ppa:ubuntu-toolchain-r/test
  apt-get -q=2 -y update
  apt-get -y install gcc-5 g++-5
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 50
}

i_gcc_debian () {
  apt-get -q=2 -y update
  apt-get -q=2 -y -t testing install gcc-5 g++-5
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 50
}

i_kernel_odroid_c1 () {
  apt-get -q=2 -y install initramfs-tools
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AB19BAC9
  echo "deb http://deb.odroid.in/c1/ trusty main" > /etc/apt/sources.list.d/odroid.list
  echo "deb http://deb.odroid.in/ trusty main" >> /etc/apt/sources.list.d/odroid.list
  apt-get -q=2 update
  mkdir -p /media/boot
  apt-get -q=2 -y install linux-image-c1 bootini
  sudo cp /boot/uImage* /media/boot/uImage
}

i_kernel_odroid_c2 () {
  apt-get -q=2 -y install initramfs-tools
  echo "#!/bin/sh" > /etc/initramfs-tools/hooks/e2fsck.sh
  echo ". /usr/share/initramfs-tools/hook-functions" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/e2fsck /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  echo "copy_exec /sbin/fsck.ext4 /sbin" >> /etc/initramfs-tools/hooks/e2fsck.sh
  chmod +x /etc/initramfs-tools/hooks/e2fsck.sh
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AB19BAC9
  echo "deb http://deb.odroid.in/c2/ xenial main" > /etc/apt/sources.list.d/odroid.list
  apt-get -q=2 update
  mkdir -p /media/boot
  apt-get -q=2 -y install linux-image-c2 bootini
  sudo cp /boot/Image* /media/boot/uImage
}

i_kernel_odroid_xu4 () {
  apt-get -q=2 -y install initramfs-tools
  curl -sSL http://deb.odroid.in/5422/pool/main/b/bootini/bootini_20151220-14_armhf.deb >/tmp/bootini.deb
  curl -sSL http://deb.odroid.in/umiddelb/linux-image-3.10.92-67_20151123_armhf.deb >/tmp/linux-image-3.10.92-67_20151123_armhf.deb
  mkdir /media/boot
  dpkg -i /tmp/bootini.deb /tmp/linux-image-3.10.92-67_20151123_armhf.deb
  rm -f /tmp/bootini.deb /tmp/linux-image-3.10.92-67_20151123_armhf.deb
}

i_kernel_utilite_pro () {
  curl -sSL https://github.com/umiddelb/z2d/blob/master/kernel/linux-3.14.51+-upro.tar.xz?raw=true | tar --numeric-owner -xJpf -
}

i_kernel_cubox_i () {
  curl -sSL https://github.com/umiddelb/z2d/blob/master/kernel/linux-4.4.0,3.14.51+-cbxi.tar.xz?raw=true | tar --numeric-owner -xJpf -
}

i_kernel_pine64 () {
  curl -sSL https://github.com/umiddelb/z2d/blob/master/kernel/linux-3.10.65+-p64.tar.xz?raw=true | tar --numeric-owner -xJpf -
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

c_ttyS_debian () {
  echo T0:2345:respawn:/sbin/getty -L $1 115200 vt100 >> etc/inittab
}

c_fw_utils () {
  echo "$1" > /etc/fw_env.config
}

c_user () {
  adduser --gecos '' $1
  usermod -aG adm,cdrom,sudo,plugdev $1
}
