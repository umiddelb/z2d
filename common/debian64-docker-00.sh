#!/bin/sh
. ./system-settings.sh

sudo apt-get -y install lxc aufs-tools cgroupfs-mount cgroup-bin apparmor 
sudo apt-get -y -t jessie-backports install docker.io
sudo usermod -aG docker ${USERNAME}
