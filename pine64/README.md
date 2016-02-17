This directory contains a collection of scripts helping you to set up a minimal Ubuntu 14.04.3 / Debian 8 Jessie 
root filesystem for your 64bit ARMv8 device (aarch64 platform): 

## Ubuntu
 - ubuntu-01.sh: debootstraps the Ubuntu userland, prepare and jump into the chroot environment
 - ubuntu-02.sh: (invoked by ubuntu-01.sh) customize the userland, install gcc-5

## Debian
 - debian-01.sh: debootstraps the Debian userland, prepare and jump into the chroot environment
 - debian-02.sh: (invoked by debian-01.sh) customize the userland, install gcc-5

You need a working qemu environment with aarch64 support (e.g. Debian Jessie) to run the scripts on an non-aarch64 device. Due to the emulation, the scripts will take some time to complete. 

You can find a prebuild root filesystem here:
 - [trusty-arm64.tar.xz](https://www.dropbox.com/s/ctlgs3qnumfdnnf/trusty-arm64.tar.xz?dl=0), user: ubuntu, password: 111111
 - [jessie_pine64.tar.xz](https://www.dropbox.com/s/zwfhz30nbvo4lyp/jessie_pine64.tar.xz?dl=0), user: debian, password: 111111

You can extract the tar archive with:
 - Ubuntu: `curl -sSL 'https://www.dropbox.com/s/ctlgs3qnumfdnnf/trusty-arm64.tar.xz?dl=0' | sudo tar --numeric-owner -xpJf -`
 - Debian: `curl -sSL 'https://www.dropbox.com/s/zwfhz30nbvo4lyp/jessie_pine64.tar.xz?dl=0' | sudo tar --numeric-owner -xpJf -`
 
## Install procedure

In order to get a complete image for your ARMv8 board, you need to add a kernel image, kernel modules and a boot loader.

### Step 0: Boot loader

Thanks to @longsleep there is an [up-to-date u-boot bootloader](https://github.com/longsleep/u-boot-pine64/tree/pine64-hacks) available for PINE64. This version is able to load its configuration and image files from ordinary plain files instead of Android/Nand partitions. @longsleep also published a [minimal image](https://www.stdin.xyz/downloads/people/longsleep/tmp/pine64-images/simpleimage-pine64-20160207-1.img.xz) containing the boot loader binaries and two partitions. The first partiton (vfat) contains the u-boot environment and the image of a 4.5 Linux kernel. The second partiton (ext4) is only a placeholder. The u-boot default configuration will load the kernel image from the first partition and passes the second partition as rootfs to the Linux kernel.

The first step is to initialize the uSD card with this minimal image:

    curl -sSL https://www.stdin.xyz/downloads/people/longsleep/tmp/pine64-images/simpleimage-pine64-20160207-1.img.xz | unxz | sudo dd of=/dev/<device_node_of_the_uSD_card> bs=1M

### Step 1: Expand the rootfs partiton

The second partiton needs to be enlarged in order to consume the entire SD card storage. Just delete the second partition and recreate it again starting with sector 143360.

    /bin/echo -e "d\n2\nn\np\n2\n143360\n\nw\n" | sudo fdisk /dev/<device_node_of_the_uSD_card>

### Step 2: Create the filesystem on the rootfs partition

    sudo mkfs.ext4 -O ^has_journal -b 4096 /dev/<device_node_of_the_uSD_card>2

### Step 3: Mount the rootfs partition 

    sudo mount /dev/<device_node_of_the_uSD_card>2 /mnt
    
### Step 4: Mount the boot partition

    sudo mkdir /mnt/boot
    sudo mount /dev/<device_node_of_the_uSD_card>1 /mnt/boot

### Step 5: Extract the Debian Jessie root filesystem (containing a 3.10.65+ Linux kernel)

    curl -sSL 'https://www.dropbox.com/s/zwfhz30nbvo4lyp/jessie_pine64.tar.xz?dl=0' | sudo tar --numeric-owner -C /mnt -xpJf -
    
### Step 6: Unmount boot and rootfs partition

    sudo umount /mnt/boot; sudo umount /mnt;
    sync; sync
