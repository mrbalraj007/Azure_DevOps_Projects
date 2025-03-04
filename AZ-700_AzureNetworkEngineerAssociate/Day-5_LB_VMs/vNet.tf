# To create a virtual network for az700-rg01 in the eastus location:
resource "azurerm_network_security_group" "rg01-sg-eastus" {
  name                = var.name_az700-rg01-sg-eastus
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name

  security_rule {
    name                       = "allow-rdp-az700-rg01-sg-eastus"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "az700-rg01-sg-eastus"
  }
}

resource "azurerm_virtual_network" "vnet1" {
  name                = var.name_az700-rg01-eastus-vnet-01
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name
  address_space       = ["10.1.0.0/16"]

  subnet {
    name           = "Public-az700-rg01-vnet-01"
    address_prefix = "10.1.0.0/24"
    security_group = azurerm_network_security_group.rg01-sg-eastus.id
  }

  subnet {
    name           = "Private-az700-rg01-vnet-01"
    address_prefix = "10.1.1.0/24"
    security_group = azurerm_network_security_group.rg01-sg-eastus.id
  }

  tags = {
    environment = "az700-rg01-env-01"
  }
}

# To create a virtual network for az700-rg01 in the westus location:
resource "azurerm_network_security_group" "rg01-sg-westus" {
  name                = var.name_az700-rg01-sg-westus
  location            = "westus"
  resource_group_name = azurerm_resource_group.rg01.name

  security_rule {
    name                       = "allow-rdp-az700-rg01-sg-westus"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "az700-rg01-sg-westus"
  }
}

resource "azurerm_virtual_network" "vnet2" {
  name                = var.name_az700-rg01-westus-vnet-01
  location            = "westus"
  resource_group_name = azurerm_resource_group.rg01.name
  address_space       = ["10.3.0.0/16"]

  subnet {
    name           = "Public-az700-rg02-vnet-01"
    address_prefix = "10.3.0.0/24"
    security_group = azurerm_network_security_group.rg01-sg-westus.id
  }

  tags = {
    environment = "az700-rg02-env-01"
  }
}
