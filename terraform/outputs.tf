# Show the public ip's of the nfs nodes to by used in Ansible hosts file
output "nfs_servers_public_ip_address" {
  description = "The actual publlic ip address allocated for the nfs servers."
  value       = azurerm_linux_virtual_machine.nfsVM[*].public_ip_address
}

# Show the public ip's of the master nodes to by used in Ansible hosts file
output "masters_servers_public_ip_address" {
  description = "The actual publlic ip address allocated for the masters servers."
  value       = azurerm_linux_virtual_machine.mastersVM[*].public_ip_address
}

# Show the public ip's of the worker nodes to by used in Ansible hosts file
output "workers_servers_public_ip_address" {
  description = "The actual publlic ip address allocated for the workers servers."
  value       = azurerm_linux_virtual_machine.workersVM[*].public_ip_address
}
