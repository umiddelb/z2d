This directory contains a collection of scripts helping you to set up a minimal Ubuntu 16.04 / Debian 8 Jessie / CentOS 7
boot device for your Pine64. I've switched to mainline U-boot firmware and mainline 4.9 Linux kernel, since the HW support has become good enough for running Docker and k8s headless on the Pine64. If you are looking for ready to use desktop / GUI images you might be happy using [Armbian](https://www.armbian.com/pine64/) instead.

## Ubuntu
 - ubuntu-core-00.sh: set up u-boot, partition & format the boot device, do the correct mounts
 - ubuntu-core-01.sh: debootstraps the Ubuntu userland, prepare and jump into the chroot environment
 - ubuntu-core-02.sh: (invoked by ubuntu-core-01.sh) customize the userland, install gcc-5

## Debian
 - debian-00.sh: set up u-boot, partition & format the boot device, do the correct mounts
 - debian-01.sh: debootstraps the Debian userland, prepare and jump into the chroot environment
 - debian-02.sh: (invoked by debian-01.sh) customize the userland, install gcc-5

## CentOS (credit goes to [KurtStam](https://github.com/KurtStam))

To create a brand new ubuntu, debian or centos image you will need a running Pine64 board and a USB adapter with the new
memory microSD card. The following are instructions specific to centos, but it should be very similar for the other 
distrubutions.

1. Get a Pine64 running with one of the [supported linux distributions](https://www.pine64.org/?page_id=1929)

2. Login to the Pine64 and Ensure that git, curl, dosfstools are installed: apt-get install -y git curl dosfstools -- they may not be installed by default.

3. Checkout this repo: git clone https://github.com/umiddelb/z2d

4. Stick in the USB drive with the new memory card. Since it is the only device plugged in it should come up as /dev/dba, but
you should double check this using `fdisk -l` to list all your devices.  Update the `dev` setting with the value you found in step 2.

~~~~
cd z2d/pine64
vi centos-00.sh 
~~~~

5. Run the centos-00.sh script, and the centos-01.sh script as long as there are no errors.

~~~~
sh centos-00.sh
sh centos-01.sh
~~~~

6. If everything completes without errors you know have a bootable microSD card with a base Centos-7 distro running the latest longsleep kernel.
After you boot up with this card, you will find two extra files on the file system: common-functions.sh an centos-03.sh. Editing and running the 
centos-03.sh script is optional. You can delete these files right after.
