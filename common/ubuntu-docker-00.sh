#!/bin/sh

sudo apt-get -y install lxc aufs-tools cgroup-lite apparmor docker.io
sudo usermod -aG docker $SUDO_USER
