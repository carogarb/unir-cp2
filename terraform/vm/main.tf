# Create a Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "cgb-unir-cp2-vnet"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name
  address_space       = ["10.0.0.0/16"]
  tags                = var.azurerm_resource_group_tags
}

# Create a Subnet in the Virtual Network
resource "azurerm_subnet" "subnet" {
  name                 = "cgb-unir-cp2-subnet"
  resource_group_name  = var.azurerm_resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a Public IP
resource "azurerm_public_ip" "ip" {
  name                = "cgb-unir-cp2-public-ip"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.azurerm_resource_group_tags
}

# Create a Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "cgb-unir-cp2-nsg"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name
  tags                = var.azurerm_resource_group_tags
}

# SSH Rule (22)
resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "Allow-SSH"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.azurerm_resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# HTTP Rule (80)
resource "azurerm_network_security_rule" "allow_http" {
  name                        = "Allow-HTTP"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.azurerm_resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Create a Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "cgb-unir-cp2-nic"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }

  tags = var.azurerm_resource_group_tags
}

# Create a Network Interface Security Group association
resource "azurerm_network_interface_security_group_association" "nics" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "cgb-unir-cp2-vm"
  location                        = var.azurerm_resource_group_location
  resource_group_name             = var.azurerm_resource_group_name
  network_interface_ids           = [azurerm_network_interface.nic.id]
  size                            = "Standard_B1ls"
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

  tags = var.azurerm_resource_group_tags
}

