output "resource_group_name" {
  description = "Nombre del RG"
  value = var.resource_group_name
}

output "location" {
  description = "Region de azure usada"
  value = var.location
}

output "vm_public_ip" {
  description = "Public IP of the VM."
  value       = azurerm_public_ip.pip.ip_address
}

output "ssh_private_key_pem" {
  description = "Private SSH key to access the VM (PEM)."
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}