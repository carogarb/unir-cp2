variable "azurerm_resource_group_name" {
  description = "Azure Resource Group Name"
  type        = string
  default     = "arg-cgb-unir-cp2"
}

variable "azurerm_resource_group_location" {
  description = "Azure Resource Group Location"
  type        = string
  default     = "West Europe"
}

variable "azurerm_resource_group_tags" {
  description = "Azure Resource Group tags (to be applied to all the resources)"
  type        = map(string)
  default     = {
    environment = "casopractico2"
  }
}

variable "azurerm_container_registry_name" {
  description = "Azure Container Registry name"
  type        = string
  default     = "cgbuniracr"
}

