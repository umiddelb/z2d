This directory contains a collection of scripts helping you to set up a minimal Ubuntu 16.04 / Debian 8 Jessie / CentOS 7
root filesystem for your 64bit ARMv8 device (aarch64 platform): 

## Ubuntu
 - ubuntu-core-00.sh: set up u-boot, partition & format the boot device, do the correct mounts
 - ubuntu-core-01.sh: debootstraps the Ubuntu userland, prepare and jump into the chroot environment
 - ubuntu-core-02.sh: (invoked by ubuntu-core-01.sh) customize the userland, install gcc-5

## Debian
 - debian-00.sh: set up u-boot, partition & format the boot device, do the correct mounts
 - debian-01.sh: debootstraps the Debian userland, prepare and jump into the chroot environment
 - debian-02.sh: (invoked by debian-01.sh) customize the userland, install gcc-5

## CentOS
 - centos-00.sh: set up u-boot, partition & format the boot device, do the correct mounts
 - centos-01.sh: downloads and unpacks the CentOS userland, prepare and jump into the chroot environment
 - centos-02.sh: (invoked by centos-01.sh) do some basic customization of the userland, install kernel so that the box will be able to boot CentOS
 - centos-03.sh: Execute /centos-03.sh after booted into CentOS, e.g. `(cd /; sudo sh centos-03.sh)`.

You need a working qemu environment with aarch64 support (e.g. Debian Jessie) to run the scripts on an non-aarch64 device. Due to the emulation, the scripts will take some time to complete. 

You can find a prebuild root filesystem here:
 - [xenial-pine64.tar.xz](https://www.dropbox.com/s/tp488tlsori4log/xenial_pine64.tar.xz?dl=0), user: ubuntu, password: 111111
 - [jessie_pine64.tar.xz](https://www.dropbox.com/s/zwfhz30nbvo4lyp/jessie_pine64.tar.xz?dl=0), user: debian, password: 111111
 - [centos7_pine64.tar.xz](https://www.dropbox.com/s/atroptjpdslhzo7/centos7_pine64.tar.xz?dl=0), user: centos, password: 111111

You can extract the tar archive with:
 - Ubuntu: `curl -sSL 'https://www.dropbox.com/s/tp488tlsori4log/xenial_pine64.tar.xz?dl=0' | sudo tar --numeric-owner -xpJf -`
 - Debian: `curl -sSL 'https://www.dropbox.com/s/zwfhz30nbvo4lyp/jessie_pine64.tar.xz?dl=0' | sudo tar --numeric-owner -xpJf -`
 - Centos: `curl -sSL 'https://www.dropbox.com/s/atroptjpdslhzo7/centos7_pine64.tar.xz?dl=0' | sudo tar --numeric-owner -xpJf -`
 
# Install procedure

In order to get a complete image for your ARMv8 board, you need to add a kernel image, kernel modules and a boot loader.

## Step 0: Boot loader

Thanks to @longsleep there is an [up-to-date u-boot bootloader](https://github.com/longsleep/u-boot-pine64/tree/pine64-hacks) available for PINE64. This version is able to load its configuration and image files from ordinary plain files instead of Android/Nand partitions. @longsleep also published a [minimal image](https://www.stdin.xyz/downloads/people/longsleep/pine64-images/simpleimage-pine64-latest.img.xz) containing the boot loader binaries and two partitions. The first partiton (vfat) contains the u-boot environment. The second partiton (ext4) is only a placeholder. The u-boot default configuration will load the kernel image from the second partition and passes the second partition as rootfs to the Linux kernel.

The first step is to initialize the uSD card with this minimal image:

    curl -sSL https://www.stdin.xyz/downloads/people/longsleep/pine64-images/simpleimage-pine64-latest.img.xz | unxz | sudo dd of=/dev/<device_node_of_the_uSD_card> bs=1M

## Step 1: Expand the rootfs partiton

The second partiton needs to be enlarged in order to consume the entire SD card storage. Just delete the second partition and recreate it again starting with sector 143360.

    /bin/echo -e "d\n2\nn\np\n2\n143360\n\nw\n" | sudo fdisk /dev/<device_node_of_the_uSD_card>

## Step 2: Create the filesystem on the rootfs partition

    sudo mkfs.ext4 -O ^has_journal -b 4096 -L rootfs -U deadbeef-dead-beef-dead-beefdeadbeef /dev/<device_node_of_the_uSD_card>2

## Step 3: Mount the rootfs partition 

    sudo mount /dev/<device_node_of_the_uSD_card>2 /mnt
    
## Step 4: Mount the bootenv partition

    sudo mkdir /mnt/bootenv
    sudo mount /dev/<device_node_of_the_uSD_card>1 /mnt/bootenv

## Step 5a: Extract the Debian Jessie root filesystem (containing a 3.10.65+ Linux kernel)

    curl -sSL 'https://www.dropbox.com/s/zwfhz30nbvo4lyp/jessie_pine64.tar.xz?dl=0' | sudo tar --numeric-owner -C /mnt -xpJf -
    
## Step 5b: Extract the Ubuntu Xenial root filesystem (containing a 3.10.65+ Linux kernel)

    curl -sSL 'https://www.dropbox.com/s/uatgjecx6qvne82/xenial_pine64.tar.xz?dl=0' | sudo tar --numeric-owner -C /mnt -xpJf -

## Step 5c: Extract the CentOS 7 root filesystem (containing a 3.10.65+ Linux kernel)

    curl -sSL 'https://www.dropbox.com/s/atroptjpdslhzo7/centos7_pine64.tar.xz?dl=0' | sudo tar --numeric-owner -C /mnt -xpJf -

## Step 6: Update to the latest 3.10.101 Linux kernel

    curl -sSL 'https://www.dropbox.com/s/qsx6jhrqjlwrbjd/linux-3.10.101-p64.tar.xz?dl=0' | sudo tar --numeric-owner -C /mnt -xphJf -
    cd /mnt/boot/conf.d/default/; sudo rm kernel && sudo ln -s ../../kernel.d/linux-3.10.101-p64 kernel

## Step 7: Unmount bootenv and rootfs partition

    sudo umount /mnt/bootenv; sudo umount /mnt;
    sync; sync
