#!/bin/sh
set -ex

timedatectl set-timezone Europe/Berlin
localectl set-locale LANG=en_GB.UTF-8

hostnamectl set-hostname p64 --static
hostnamectl set-hostname "Pine 64" --pretty

c_docker_centos_fedora
