# To create a virtual network for az700-rg01 in the eastus location:
resource "azurerm_network_security_group" "rg01-sg" {
  name                = "az700-rg01-sg"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name

  security_rule {
    name                       = "allow-rdp-az700-rg01-sg"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "25", "80", "443", "465", "3000", "6443", "9000", "27017", "3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "az700-rg01-sg"
  }

}


resource "azurerm_virtual_network" "vnet1" {
  name                = "az700-rg01-vnet-01"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  address_space       = ["10.1.0.0/16"]

  subnet {
    name           = "Public-az700-rg01-vnet-01"
    address_prefix = "10.1.0.0/24"
    security_group = azurerm_network_security_group.rg01-sg.id

  }

  subnet {
    name           = "Private-az700-rg01-vnet-01"
    address_prefix = "10.1.1.0/24"
    security_group = azurerm_network_security_group.rg01-sg.id
  }

  tags = {
    environment = "az700-rg01-env-01"
  }
}


# To create a virtual network for az700-rg02 in the eastus location:
resource "azurerm_network_security_group" "rg02-sg" {
  name                = "az700-rg02-sg"
  location            = azurerm_resource_group.rg02.location
  resource_group_name = azurerm_resource_group.rg02.name

  security_rule {
    name                       = "allow-rdp-az700-rg02-sg"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "25", "80", "443", "465", "3000", "6443", "9000", "27017", "3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "az700-rg02-sg"
  }
}


resource "azurerm_virtual_network" "vnet2" {
  name                = "az700-rg02-vnet-01"
  location            = azurerm_resource_group.rg02.location
  resource_group_name = azurerm_resource_group.rg02.name
  address_space       = ["10.2.0.0/16"]
  //dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "Public-az700-rg02-vnet-01"
    address_prefix = "10.2.0.0/24"
    security_group = azurerm_network_security_group.rg02-sg.id
  }

  tags = {
    environment = "az700-rg02-env-01"
  }
}

# To create a virtual network for az700-rg03 in the westus location:
resource "azurerm_network_security_group" "rg03-sg" {
  name                = "az700-rg03-sg"
  location            = azurerm_resource_group.rg03.location
  resource_group_name = azurerm_resource_group.rg03.name
  security_rule {
    name                       = "allow-rdp-az700-rg03-sg"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "25", "80", "443", "465", "3000", "6443", "9000", "27017", "3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "az700-rg03-sg"
  }
}


resource "azurerm_virtual_network" "vnet3" {
  name                = "az700-rg03-vnet-01"
  location            = azurerm_resource_group.rg03.location
  resource_group_name = azurerm_resource_group.rg03.name
  address_space       = ["10.3.0.0/16"]
  //dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "Public-az700-rg03-vnet-01"
    address_prefix = "10.3.0.0/24"
  }

  tags = {
    environment = "az700-rg03-env-01"
  }
}