#!/bin/bash

function flag_ipv6() {
  sudo sysctl net.ipv6.conf.all.disable_ipv6=$1
}

set -x

sudo apt install software-properties-common python3 python3-pip python3-setuptools -y
python3 --version

sudo pip3 install requests pyyaml

# fingerprint from: https://launchpad.net/~ansible/+archive/ubuntu/ansible
# this is to avoid key problems when apt-add-repository is run
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367

# temporarily disable ipv6 which can make apt-add-repository take 10+ minutes
flag_ipv6 1
sudo -E apt-add-repository --yes ppa:ansible/ansible
flag_ipv6 0

sudo apt-get update
sudo apt-get install ansible-core -y

ansible --version

ansible -m ping localhost


