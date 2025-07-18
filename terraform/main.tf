# Set the Azure Provider source and version being used
terraform {
  required_version = ">= 1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.1.0"
    }
  }
}

# Configure the Microsoft Azure provider using our subscription ID (az account show -> id value)
provider "azurerm" {
  subscription_id = "f8284bfd-65fe-473a-8027-04a3fedb535d" 
  features {}
}

# Create a Resource Group if it doesn’t exist
resource "azurerm_resource_group" "rg" {
  name     = var.azurerm_resource_group_name
  location = var.azurerm_resource_group_location
  tags = var.azurerm_resource_group_tags
}

# Use vm module to create and configure the virtual  machine
module "virtual_machine" {
  source = "./vm"  
  azurerm_resource_group_name     = azurerm_resource_group.rg.name
  azurerm_resource_group_location = azurerm_resource_group.rg.location
  azurerm_resource_group_tags     = var.azurerm_resource_group_tags
}

# Use acr module to create the Azure Container registry
module "azure_container_registry" {
  source         = "./acr"
  azurerm_resource_group_name     = azurerm_resource_group.rg.name
  azurerm_resource_group_location = azurerm_resource_group.rg.location
  azurerm_resource_group_tags     = var.azurerm_resource_group_tags
  azurerm_container_registry_name = var.azurerm_container_registry_name
}

# Use aks module to create the Azure Kubernetes Cluster
module "azurerm_kubernetes_cluster" {
  source         = "./aks"
  azurerm_resource_group_name     = azurerm_resource_group.rg.name
  azurerm_resource_group_location = azurerm_resource_group.rg.location
  azurerm_resource_group_tags     = var.azurerm_resource_group_tags
  azurerm_kubernetes_cluster_name = var.azurerm_kubernetes_cluster_name
  azurerm_resource_group_id       = azurerm_resource_group.rg.id
}

/* 
# Only for testing purpose!!
# Configurate to run automated tasks in the VM start-up
resource "azurerm_virtual_machine_extension" "vme" {
  name                 = "hostname"
  virtual_machine_id   = module.virtual_machine.vm_id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
      "commandToExecute": "echo 'Hello, World' > index.html ; nohup busybox httpd -f -p 8080 &"
    }
  SETTINGS

  tags = azurerm_resource_group.rg.tags
}
 */