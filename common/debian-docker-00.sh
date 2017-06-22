#!/bin/sh

sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common 

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

echo "deb https://download.docker.com/linux/debian $(lsb_release -cs) test" | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update
sudo apt-get install -y docker-ce

sudo usermod -aG docker debian
