#!/bin/bash
#
# I have used 192.168.2.0/24 to define the MetalLB endpoint IP addresses in these scripts
# But on your own host network is probably different (e.g. 192.168.1.0 ?) if you in a lab or home network
#
# This script uses sed to replace '192.168.2.' with the correct network for your environment
#
#

if [ $# -lt 2 ]; then
  echo "Usage: <firstThreeOctetsOfSourceNetwork>. <firstThreeOctetsOfTargetNetwork>."
  echo "Example: ./set_metal_lb_network.sh 192.168.2. 192.168.1."
  exit 1
else
  source_network="$1"
  target_network="$2"
fi

if [[ ! $source_network == *\. ]]; then
  echo "ERROR the source network should end with a period, Try again using ${source_network}."
  exit 2
fi
if [[ ! $target_network == *\. ]]; then
  echo "ERROR the target network should end with a period, Try again using ${target_network}."
  exit 2
fi

echo "Replacing $source_network with $target_network in relevant files..."
for file in tf-libvirt/terraform.tfvars group_vars/master ; do 
  #echo "doing replacement in $file"
  set -ex
  sed -i "s/$source_network/$target_network/g" $file
  set +ex
done

echo "DONE"
