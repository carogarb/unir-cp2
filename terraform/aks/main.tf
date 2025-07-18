resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.azurerm_kubernetes_cluster_name
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name
  dns_prefix          = "dns-prefix-k8s"
  sku_tier            = "Free"
# kubernetes_version  = "1.26.3"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  tags = var.azurerm_resource_group_tags
}

resource "azurerm_role_assignment" "acr_role" {
  scope                = var.azurerm_resource_group_id
  role_definition_name = "AcrRole"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}