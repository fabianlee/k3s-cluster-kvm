output "hosts_1_network" {
  value = libvirt_domain.domain-ubuntu["k3s-1"].network_interface[*]
}
output "hosts_2_network" {
  value = libvirt_domain.domain-ubuntu["k3s-2"].network_interface[*]
}
output "hosts_3_network" {
  value = libvirt_domain.domain-ubuntu["k3s-3"].network_interface[*]
}
output "hosts" {
  # output does not support 'for_each', so use zipmap as workaround
  value = zipmap(
                values(libvirt_domain.domain-ubuntu)[*].name,
                values(libvirt_domain.domain-ubuntu)[*].vcpu
                )
}

