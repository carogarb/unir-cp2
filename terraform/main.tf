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
  name     = "cgb-unir-cp2"
  location = "West Europe"
  tags = {
    department = "casopractico2"
  } 
}

# Create a Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "cgb-unir-cp2-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  tags = azurerm_resource_group.rg.tags
}

# Create a Subnet in the Virtual Network
resource "azurerm_subnet" "subnet" {
  name                 = "cgb-unir-cp2-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a Public IP
resource "azurerm_public_ip" "ip" {
  name                = "cgb-unir-cp2-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = azurerm_resource_group.rg.tags
}

# Create a Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "cgb-unir-cp2-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = azurerm_resource_group.rg.tags
}

# HTTP Rule (8080)
resource "azurerm_network_security_rule" "allow_http" {
  name                        = "Allow-HTTP"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Create a Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "cgb-unir-cp2-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }

  tags = azurerm_resource_group.rg.tags
}

# Create a Network Interface Security Group association
resource "azurerm_network_interface_security_group_association" "nics" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "cgb-unir-cp2-vm"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  network_interface_ids           = [azurerm_network_interface.nic.id]
  size                            = "Standard_DS1_v2"
  computer_name                   = "cgbvm"
  admin_username                  = "cgb"
  admin_password                  = "Password1234!"
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = azurerm_resource_group.rg.tags
}

# Configurate to run automated tasks in the VM start-up
resource "azurerm_virtual_machine_extension" "vme" {
  name                 = "hostname"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
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

# Data source to access the properties of an existing Azure Public IP Address
data "azurerm_public_ip" "ipdata" {
  name                = azurerm_public_ip.ip.name
  resource_group_name = azurerm_linux_virtual_machine.vm.resource_group_name
}

# Output variable: Public IP address
output "public_ip" {
  value = data.azurerm_public_ip.ipdata.ip_address
}

