variable "password" { default="linux" }
variable "dns_domain" { default="fabian.lee"  }
variable "ip_type" { default = "static" }

# kvm standard default network
variable "prefixIP" { default = "192.168.122" }

# kvm disk pool name
variable "diskPool" { default = "default" }

# additional nics on k3s-1
variable "additional_nic1" { default="192.168.1.143" }
variable "additional_nic2" { default="192.168.1.144" }

variable "qemu_connect" { default="qemu:///system" }

