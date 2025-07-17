# Output: Public IP of the VM (terraform output -raw vm_ip)
output "vm_ip" {
  value = module.virtual_machine.vm_public_ip
}

# Output: ACR Name (terraform output -raw acr_name)
output "acr_name" {
  value = module.azure_container_registry.name
}

# Output: ACR Username (terraform output -raw acr_username)
output "acr_username" {
  value = module.azure_container_registry.acr_username
}

# Output: ACR Password (terraform output -raw acr_password)
output "acr_password" {
  value       = module.azure_container_registry.acr_password
  sensitive   = true
}