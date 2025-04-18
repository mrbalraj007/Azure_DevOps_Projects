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

  tags = {
    environment = "az700-rg01-centralindia-env"
  }
}

# To create a virtual network for az700-rg01 in the East US location:
resource "azurerm_network_security_group" "rg01-sg-eastus" {
  name                = var.name_az700-rg01-sg-eastus
  location            = var.location_02
  resource_group_name = azurerm_resource_group.rg01.name

  security_rule {
    name                       = "allow-rdp-az700-rg01-sg-eastus"
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
    environment = var.name_az700-rg01-sg-eastus
  }
}

resource "azurerm_virtual_network" "vnet2" {
  name                = var.name_az700-rg01-eastus-vnet-01
  location            = var.location_02
  resource_group_name = azurerm_resource_group.rg01.name
  address_space       = var.eastus_address_space

  subnet {
    name           = var.eastus_public_subnet_name
    address_prefix = var.eastus_public_subnet_prefix
    security_group = azurerm_network_security_group.rg01-sg-eastus.id
  }

  subnet {
    name           = var.eastus_private_subnet_name
    address_prefix = var.eastus_private_subnet_prefix
    security_group = azurerm_network_security_group.rg01-sg-eastus.id
  }

  tags = {
    environment = "az700-rg01-eastus-env"
  }
}

# Remove the following westus resources as they're not needed anymore
# resource "azurerm_network_security_group" "rg01-sg-westus" {
#   name                = var.name_az700-rg01-sg-westus
#   location            = var.location_02
#   resource_group_name = azurerm_resource_group.rg01.name
#   
#   security_rule {
#     name                       = "allow-rdp-az700-rg01-sg-westus"
#     priority                   = 600
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_ranges    = var.allowed_ports
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#   
#   tags = {
#     environment = var.name_az700-rg01-sg-westus
#   }
# }
# 
# resource "azurerm_virtual_network" "vnet2" {  <-- THIS IS THE DUPLICATE
#   name                = var.name_az700-rg01-westus-vnet-01
#   location            = var.location_02
#   resource_group_name = azurerm_resource_group.rg01.name
#   address_space       = var.westus_address_space
# 
#   subnet {
#     name           = var.westus_public_subnet_name
#     address_prefix = var.westus_public_subnet_prefix
#     security_group = azurerm_network_security_group.rg01-sg-westus.id
#   }
# 
#   tags = {
#     environment = "az700-rg02-env-01"
#   }
# }
