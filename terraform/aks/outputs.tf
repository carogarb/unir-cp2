
output "aks_id" {
  description = "AKS ID"
  value       = azurerm_kubernetes_cluster.aks.id
}