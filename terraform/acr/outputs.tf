output "acr_name" {
  description = "ACR Name"
  value       = azurerm_container_registry.acr.name
}

output "acr_username" {
  description = "ACR Admin Username"
  value       = azurerm_container_registry.acr.admin_username
}

output "acr_password" {
  description = "ACR Admin Password"
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}

output "acr_id" {
  description = "ACR ID"
  value       = azurerm_container_registry.acr.id
}