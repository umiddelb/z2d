This directory contains a collection of scripts helping you to set up a minimal Ubuntu 14.04.3 / Debian 8 Jessie 
root filesystem for your 64bit ARMv8 device (aarch64 platform): 

## Ubuntu
 - ubuntu-01.sh: debootstraps the Ubuntu userland, prepare and jump into the chroot environment
 - ubuntu-02.sh: (invoked by ubuntu-01.sh) customize the userland, install gcc-5

## Debian
 - debian-01.sh: debootstraps the Debian userland, prepare and jump into the chroot environment
 - debian-02.sh: (invoked by debian-01.sh) customize the userland, install gcc-5

You need a working qemu environment with aarch64 support to run the scripts, e.g. Debian Jessie. Due to the emulation, 
the scripts will take some time to complete. 

You can find a prebuild root filesystem here:
 - [trusty-arm64.tar.xz](https://www.dropbox.com/s/ctlgs3qnumfdnnf/trusty-arm64.tar.xz?dl=0), user: ubuntu, password: 111111
 - [jessie-arm64.tar.xz](https://www.dropbox.com/s/mymvgw29mopqyul/jessie-arm64.tar.xz?dl=0), user: debian, password: 111111

You can extract the tar archive with:
 - Ubuntu: `curl -sSL 'https://www.dropbox.com/s/ctlgs3qnumfdnnf/trusty-arm64.tar.xz?dl=0' | sudo tar --numeric-owner -xpJf -`
 - Debian: `curl -sSL 'https://www.dropbox.com/s/mymvgw29mopqyul/jessie-arm64.tar.xz?dl=0' | sudo tar --numeric-owner -xpJf -`
 
In order to get a complete image for your ARMv8 board, you need to add a kernel image, kernel modules and a boot loader. 
