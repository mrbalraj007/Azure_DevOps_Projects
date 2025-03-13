# To create a virtual network for az700-rg01 in the Central India location:
resource "azurerm_network_security_group" "rg01-sg-centralindia" {
  name                = var.name_az700-rg01-sg-centralindia
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name

  security_rule {
    name                       = "allow-rdp-az700-rg01-sg-centralindia"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = var.allowed_ports
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.name_az700-rg01-sg-centralindia
  }
}

resource "azurerm_virtual_network" "vnet1" {
  name                = var.name_az700-rg01-centralindia-vnet-01
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name
  address_space       = var.centralindia_address_space

  subnet {
    name           = var.centralindia_public_subnet_name
    address_prefix = var.centralindia_public_subnet_prefix
    security_group = azurerm_network_security_group.rg01-sg-centralindia.id
  }

  subnet {
    name           = var.centralindia_private_subnet_name
    address_prefix = var.centralindia_private_subnet_prefix
    security_group = azurerm_network_security_group.rg01-sg-centralindia.id
  }

  subnet {
    name           = var.centralindia_nva_subnet_name
    address_prefix = var.centralindia_nva_subnet_prefix
    security_group = azurerm_network_security_group.rg01-sg-centralindia.id
  }

  tags = {
    environment = var.tag_environment_vnet
  }
}
