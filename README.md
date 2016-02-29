# Zero to Docker with Ubuntu Core or Debian within 5 minutes

This repo contains a collection of scripts helping you to set up Ubuntu Core 14.04.3 / Debian 8 Jessie and Docker 
on your ARMv7 device within less than five minutes. Each subdirectory has this collection of scripts: 

## Ubuntu Core
- ubuntu-core-00.sh: set up u-boot, partition & format the boot device, do the correct mounts
- ubuntu-core-01.sh: unpacks the Ubuntu Core userland, prepare and jump into the chroot environment
- ubuntu-core-02.sh: (invoked by ubuntu-core-01.sh) customize the userland, install gcc-5, install the kernel image
- ubuntu-docker-00.sh: setup docker in the newly booted environment (doesn't work in chroot)

## Debian
- debian-00.sh: set up u-boot, partition & format the boot device, do the correct mounts
- debian-01.sh: debootstraps the Debian userland, prepare and jump into the chroot environment
- debian-02.sh: (invoked by ubuntu-core-01.sh) customize the userland, install gcc-5, install the kernel image
- debian-docker-00.sh: setup docker in the newly booted environment (doesn't work in chroot)

Please choose the correct device (e.g. SD card reader) to be taken in `ubuntu-core-00.sh` / `debian-00.sh`.

You can find a step by step description [here](http://forum.odroid.com/viewtopic.php?p=91036#p91036).
