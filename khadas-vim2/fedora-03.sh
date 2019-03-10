#!/bin/sh
set -ex

. ./common-functions.sh

i_base_fedora

timedatectl set-timezone Europe/Berlin
localectl set-locale LANG=en_GB.UTF-8

hostnamectl set-hostname kvim2 --static
hostnamectl set-hostname "Khadas VIM2" --pretty

c_docker_centos_fedora
