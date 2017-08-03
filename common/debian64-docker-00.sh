#!/bin/sh

sudo apt-get -y install lxc aufs-tools cgroupfs-mount cgroup-bin apparmor 
curl -sSL https://github.com/docbobo/docker/releases/download/v17.05.0-ce/{docker-engine_17.05.0.ce-0.debian-jessie_arm64.deb} -o /tmp/#1
sudo apt install libltdl7
sudo dpkg -i /tmp/docker-engine_*.deb
rm -f /tmp/docker-engine_*.deb
sudo usermod -aG docker debian
