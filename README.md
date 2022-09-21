# K3s cluster with primary and secondary NGINX or Istio ingress

Blog installation: https://fabianlee.org/2021/09/12/kubernetes-k3s-cluster-on-ubuntu-using-ansible/
Blog NGINX: https://fabianlee.org/2021/09/16/kubernetes-k3s-with-multiple-istio-ingress-gateways/
Blog Istio: https://fabianlee.org/2021/09/16/kubernetes-k3s-with-multiple-istio-ingress-gateways/

## K3s Cluster Installation

Modify variables for environment
  * vi group_vars/all

Prereq for scripts
  * ansible-playbook install_dependencies.yml

Create guest OS with KVM
  * ansible-playbook playbook_terraform.yml

Install k3s:
  * sudo ls /tmp
  * ansible-playbook playbook_k3s_prereq.yml
  * ansible-playbook playbook_k3s.yml

Install MetalLB and certificates
  * ansible-playbook playbook_metallb.yml
  * ansible-playbook playbook_certs.yml

## Choose between NGINX Ingress

  * ansible-playbook playbook_nginx.yml
  * ansible-playbook playbook_nginx_test.yml

## OR Istio Ingress 

  * ansible-playbook playbook_istio.yml
  * ansible-playbook playbook_istio_test.yml

## Validate Cluster

Validate kubectl locally:
  * export KUBECONFIG=/tmp/k3s-kubeconfig
  * kubectl get services -A

Validate ingress locally:
  * add entries to local /etc/hosts
    192.168.2.143 k3s.local
    192.168.2.144 k3s-secondary.local

  * test nginx ingress
    ./test-nginx-endpoints.sh
  OR
  * test istio ingress
    ./test-istio-endpoints.sh

