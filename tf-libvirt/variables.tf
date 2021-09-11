variable "password" { default="linux" }
variable "dns_domain" { default="fabian.lee"  }
variable "ip_type" { default = "static" }

# kvm standard default network
variable "prefixIP" { default = "192.168.122" }

# kvm disk pool name
variable "diskPool" { default = "default" }

# additional nics on microk8s-1
variable "additional_nic1" { }
variable "additional_nic2" { }

