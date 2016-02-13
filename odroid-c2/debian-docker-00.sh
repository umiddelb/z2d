#!/bin/sh

sudo apt-get -y install dmsetup/testing
sudo apt-get -y install lxc aufs-tools cgroupfs-mount cgroup-bin apparmor docker.io
sudo usermod -aG docker debian
