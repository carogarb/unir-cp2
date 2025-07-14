variable "azurerm_resource_group_name" {
  description = "Azure resource group name"
  type        = string
}

variable "azurerm_resource_group_location" {
  description = "Azure resource group location"
  type        = string
}

variable "azurerm_resource_group_tags" {
  description = "Azure resource group tags to be applied to all the resources"
  type        = map(string)
}