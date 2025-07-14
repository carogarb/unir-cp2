# Create Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = var.azurerm_container_registry_name
  resource_group_name = var.azurerm_resource_group_name
  location            = var.azurerm_resource_group_location
  sku                 = "Basic"  
  admin_enabled       = true
  tags                = var.azurerm_resource_group_tags
}