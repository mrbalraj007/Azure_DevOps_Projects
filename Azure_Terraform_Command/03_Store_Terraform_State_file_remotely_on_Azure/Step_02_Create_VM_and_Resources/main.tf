# Data block to check if the resource group exists
data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

# Resource block to create the resource group if it doesn't exist
resource "azurerm_resource_group" "example" {
  count    = length(data.azurerm_resource_group.existing.id) == 0 ? 1 : 0
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Virtual network
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = length(data.azurerm_resource_group.existing.id) > 0 ? data.azurerm_resource_group.existing.location : azurerm_resource_group.example[0].location
  resource_group_name = length(data.azurerm_resource_group.existing.id) > 0 ? data.azurerm_resource_group.existing.name : azurerm_resource_group.example[0].name
}

# Subnet
resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = length(data.azurerm_resource_group.existing.id) > 0 ? data.azurerm_resource_group.existing.name : azurerm_resource_group.example[0].name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Network interface
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = length(data.azurerm_resource_group.existing.id) > 0 ? data.azurerm_resource_group.existing.location : azurerm_resource_group.example[0].location
  resource_group_name = length(data.azurerm_resource_group.existing.id) > 0 ? data.azurerm_resource_group.existing.name : azurerm_resource_group.example[0].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

# Network security group
resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = length(data.azurerm_resource_group.existing.id) > 0 ? data.azurerm_resource_group.existing.location : azurerm_resource_group.example[0].location
  resource_group_name = length(data.azurerm_resource_group.existing.id) > 0 ? data.azurerm_resource_group.existing.name : azurerm_resource_group.example[0].name

  security_rule {
    name              = "test-sg"
    priority          = 100
    direction         = "Inbound"
    access            = "Allow"
    protocol          = "Tcp"
    source_port_range = "*"
    destination_port_ranges    = ["22", "80", "443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "test"
  }
}

# Public IP
resource "azurerm_public_ip" "example" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = length(data.azurerm_resource_group.existing.id) > 0 ? data.azurerm_resource_group.existing.name : azurerm_resource_group.example[0].name
  location            = length(data.azurerm_resource_group.existing.id) > 0 ? data.azurerm_resource_group.existing.location : azurerm_resource_group.example[0].location
  allocation_method   = "Static"

  tags = {
    environment = "test"
  }
}

# Network interface security group association
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

# Linux virtual machine
resource "azurerm_linux_virtual_machine" "example" {
  name                            = "example-machine"
  resource_group_name             = length(data.azurerm_resource_group.existing.id) > 0 ? data.azurerm_resource_group.existing.name : azurerm_resource_group.example[0].name
  location                        = length(data.azurerm_resource_group.existing.id) > 0 ? data.azurerm_resource_group.existing.location : azurerm_resource_group.example[0].location
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = "Windows@123456"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}