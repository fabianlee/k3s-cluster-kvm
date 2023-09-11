THISDIR := $(notdir $(CURDIR))
PROJECT := $(THISDIR)
# system connection, in case LIBVIRT_DEFAULT_URI env var is not defined
LIBVIRT_URI := qemu:///system
TF := terraform

apply: init libvirt-prereq
	$(TF) apply -auto-approve

init: create-keypair
	$(TF) init

destroy: virsh-snapshot-delete
	$(TF) destroy -auto-approve
	./clean-known-hosts.sh
	#rm terraform.tfstate*

## create public/private keypair for ssh
create-keypair:
	# skips if file already exists
	[ -f id_rsa ] || ssh-keygen -t rsa -b 4096 -f id_rsa -C $(PROJECT) -N "" -q

refresh:
	$(TF) refresh
	$(TF) output

libvirt-prereq:
	@echo Making sure libvirt default disk pool and network exist
	virsh --connect $(LIBVIRT_URI) pool-info default
	virsh --connect $(LIBVIRT_URI) net-info default

	@echo Making sure virtual bridge 'br0' exists on host
        @echo https://fabianlee.org/2019/04/01/kvm-creating-a-bridged-network-with-netplan-on-ubuntu-bionic/
	ip a show br0
	@echo Making sure libvirt 'host-bridge' exists that uses 'br0' host bridge
	virsh --connect $(LIBVIRT_URI) net-info host-bridge

libvirt-pool:
	$(eval POOLDIR=$(shell virsh --connect ${LIBVIRT_URI} pool-dumpxml default | grep -E "<path>.*</path>" | grep -Po "(?<=\>)[^<]+"))
	@echo POOLDIR is $(POOLDIR)

## validate syntax of cloud_init
validate-cloud-config:
	cloud-init devel schema --config-file cloud_init.cfg

## older libvirt needed diskspec and still did not create proper internal disk snapshot.
## --disk-only --diskspec vda,snapshot=internal --diskspec hdd,snapshot=no
virsh-snapshot-create: virsh-stop-all
	echo "older libvirt/qemu on Ubuntu 20 needed diskspec, ubuntu22 libvirt8.0/qemu6.2 does not require"
	sleep 5
	virsh version
	virsh snapshot-create-as k3s-1-192.168.122.213 --name adv-test
	virsh snapshot-create-as k3s-2-192.168.122.214 --name adv-test
	virsh snapshot-create-as k3s-3-192.168.122.215 --name adv-test

virsh-snapshot-delete: virsh-stop-all
	sleep 5
	virsh version
	virsh snapshot-delete k3s-1-192.168.122.213 adv-test || true
	virsh snapshot-delete k3s-2-192.168.122.214 adv-test || true
	virsh snapshot-delete k3s-3-192.168.122.215 adv-test || true

virsh-snapshot-revert: virsh-stop-all
	sleep 5
	virsh snapshot-revert k3s-1-192.168.122.213 --snapshotname adv-test
	virsh snapshot-revert k3s-2-192.168.122.214 --snapshotname adv-test
	virsh snapshot-revert k3s-3-192.168.122.215 --snapshotname adv-test
	virsh start k3s-1-192.168.122.213 || true
	virsh start k3s-2-192.168.122.214 || true
	virsh start k3s-3-192.168.122.215 || true

virsh-start-all:
	echo "Starting all VMs..."
	virsh start k3s-1-192.168.122.213 || true
	virsh start k3s-2-192.168.122.214 || true
	virsh start k3s-3-192.168.122.215 || true
virsh-stop-all:
	echo "Stopping all VMs..."
	virsh destroy k3s-1-192.168.122.213 || true
	virsh destroy k3s-2-192.168.122.214 || true
	virsh destroy k3s-3-192.168.122.215 || true
