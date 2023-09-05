#!/bin/bash
#
# K3s is a lightweight Kubernetes implementation
# this script shows you which subcomponents are running at which address and ports
#

log_file=$(sudo k3s --version | grep "^k3s version" | cut -d' ' -f3)

outputfile="ports-$log_file.log"
sudo k3s --version > $outputfile

echo "kube-scheduler:" >> $outputfile
sudo journalctl -u k3s --no-pager | grep 'Running kube-scheduler ' | tail -n1 | grep -Po '\-\-bind-address=([^ ]*)|\-\-secure-port=(\d*)' >> $outputfile

echo "kube-controller-manager:" >> $outputfile
sudo journalctl -u k3s --no-pager | grep 'Running kube-controller-manager ' | tail -n1 | grep -Po '\-\-bind-address=([^ ]*)|\-\-secure-port=(\d*)'  >> $outputfile

echo "kubelet:" >> $outputfile
sudo journalctl -u k3s --no-pager | grep 'Running kubelet ' | tail -n1 | grep -Po '\-\-address=(.*?) ' >> $outputfile

echo "cloud-controller-manager:" >> $outputfile
sudo journalctl -u k3s --no-pager | grep 'Running cloud-controller-manager ' | tail -n1 | grep -Po '\-\-bind-address=([^ ]*)' >> $outputfile

echo "kube-apiserver:" >> $outputfile
sudo journalctl -u k3s --no-pager | grep 'Running kube-apiserver ' | tail -n1 | grep -Po '\-\-advertise-address=([^ ]*) |\-\-advertise-port=(\d*)' >> $outputfile

echo "kube-proxy:" >> $outputfile
sudo journalctl -u k3s --no-pager | grep 'Running kube-proxy' | tail -n1 | grep -Po '\-\-bind-address=([^ ]*)|\-\-metrics-bind-address=([^ ]*)' >> $outputfile

cat $outputfile
