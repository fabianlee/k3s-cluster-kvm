#!/bin/bash
#
# Creates NFS server on host server
#

sudo apt install nfs-common nfs-kernel-server

sudo mkdir -p /data/nfs1
sudo chown nobody:nogroup /data/nfs1
sudo chmod g+rwxs /data/nfs1

if grep "^/data/nfs1" /etc/exports; then
  echo "SKIP already added /data/nfs1 to exports"
else
  echo -e "/data/nfs1\t192.168.0.0/16(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports
fi

sudo exportfs -av

# restart and show logs
sudo systemctl restart nfs-kernel-server
sudo systemctl status nfs-kernel-server

# show exports
echo ""
showmount -e localhost
