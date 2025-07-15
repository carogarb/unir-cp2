output "acr_login_server" {
  description = "ACR Login Server"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_username" {
  description = "ACR Admin Username"
  value       = azurerm_container_registry.acr.admin_username
}

output "acr_password" {
  description = "ACR Admin Password"
  value       = azurerm_container_registry.acr.admin_password
  //sensitive   = true
}

output "acr_id" {
  description = "ACR ID"
  value       = azurerm_container_registry.acr.id
}