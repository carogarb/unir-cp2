output "vm_id" {
  description = "VM ID"
  value       =  azurerm_linux_virtual_machine.vm.id
}

output "vm_public_ip" {
  description = "VM Public IP"
  value       = azurerm_public_ip.ip.ip_address
}
