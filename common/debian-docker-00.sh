#!/bin/sh

sudo apt-get -y install lxc aufs-tools cgroupfs-mount cgroup-bin apparmor docker.io/jessie-backports
sudo service docker stop
curl -sSL https://github.com/umiddelb/armhf/blob/master/bin/docker-1.9.0?raw=true | sudo dd of=/usr/bin/docker
sudo service docker start
sudo usermod -aG docker $SUDO_USER
