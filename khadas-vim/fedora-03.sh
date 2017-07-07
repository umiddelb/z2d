#!/bin/sh
set -ex

timedatectl set-timezone Europe/Berlin
localectl set-locale LANG=en_GB.UTF-8

hostnamectl set-hostname kvim --static
hostnamectl set-hostname "Khadas VIM" --pretty

c_docker_centos_fedora
