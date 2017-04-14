# Zero to Docker with Ubuntu Core, Debian or CentOS within 5 minutes

This repo contains a collection of scripts helping you to set up Ubuntu Core 16.04 / Debian 8 Jessie / CentOS 7 and Docker 
on your ARM device within a couple minutes. Each subdirectory has this collection of scripts: 

## Ubuntu Core
- ubuntu-core-00.sh: set up u-boot, partition & format the boot device, do the correct mounts
- ubuntu-core-01.sh: unpacks the Ubuntu Core userland, prepare and jump into the chroot environment
- ubuntu-core-02.sh: (invoked by ubuntu-core-01.sh) customize the userland, install gcc-5, install the kernel image
- ubuntu-docker-00.sh: setup Docker in the newly booted environment (doesn't work in chroot)

## Debian
- debian-00.sh: set up u-boot, partition & format the boot device, do the correct mounts
- debian-01.sh: debootstraps the Debian userland, prepare and jump into the chroot environment
- debian-02.sh: (invoked by debian-01.sh) customize the userland, install gcc-5, install the kernel image
- debian-docker-00.sh: setup Docker in the newly booted environment (doesn't work in chroot)

## CentOS
- centos-00.sh: set up u-boot, partition & format the boot device, do the correct mounts
- centos-01.sh: unpacks the CentOS userland, prepare and jump into the chroot environment
- centos-02.sh: (invoked by centos-01.sh) customize the userland, install the kernel image
- centos-03.sh: install/update packages, setup Docker in the newly booted environment (doesn't work in chroot)

Please choose the correct device (e.g. SD card reader) to be taken in `ubuntu-core-00.sh` / `debian-00.sh` / `centos-00.sh`.
