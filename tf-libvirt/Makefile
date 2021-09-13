THISDIR := $(notdir $(CURDIR))
PROJECT := $(THISDIR)
# system connection, in case LIBVIRT_DEFAULT_URI env var is not defined
LIBVIRT_URI := qemu:///system
TF := terraform

apply: init 
	@echo Making sure libvirt pool 'default' exists
	virsh --connect $(LIBVIRT_URI) pool-info default
	$(TF) apply -auto-approve

init: create-keypair
	# skips init if .terraform directory already exists
	[ -d .$(TF) ] || $(TF) init

destroy:
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

libvirt-pool:
	$(eval POOLDIR=$(shell virsh --connect ${LIBVIRT_URI} pool-dumpxml default | grep -E "<path>.*</path>" | grep -Po "(?<=\>)[^<]+"))
	@echo POOLDIR is $(POOLDIR)

## validate syntax of cloud_init
validate-cloud-config:
	cloud-init devel schema --config-file cloud_init.cfg

virsh-create-snapshot:
	virsh snapshot-create-as microk8s-1-192.168.122.210 --name adv-test --disk-only --diskspec vda,snapshot=internal --diskspec hdd,snapshot=no
	virsh snapshot-create-as microk8s-2-192.168.122.211 --name adv-test --disk-only --diskspec vda,snapshot=internal --diskspec hdd,snapshot=no
	virsh snapshot-create-as microk8s-3-192.168.122.212 --name adv-test --disk-only --diskspec vda,snapshot=internal --diskspec hdd,snapshot=no

virsh-snapshot-delete:
	virsh destroy microk8s-1-192.168.122.210
	virsh destroy microk8s-2-192.168.122.211
	virsh destroy microk8s-3-192.168.122.212
	sleep 5
	virsh snapshot-delete microk8s-1-192.168.122.210 adv-test
	virsh snapshot-delete microk8s-2-192.168.122.211 adv-test
	virsh snapshot-delete microk8s-3-192.168.122.212 adv-test
