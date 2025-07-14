output "vm_public_ip" {
  description = "VM Public IP"
  value       = azurerm_public_ip.ip.ip_address
}
