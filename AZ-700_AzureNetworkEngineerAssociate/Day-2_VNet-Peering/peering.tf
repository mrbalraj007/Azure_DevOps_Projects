data "azurerm_virtual_network" "vnet1" {
  name                = var.vnet1_name
  resource_group_name = var.rg_name_1
}

data "azurerm_virtual_network" "vnet2" {
  name                = var.vnet2_name
  resource_group_name = var.rg_name_2
}

data "azurerm_virtual_network" "vnet3" {
  name                = var.vnet3_name
  resource_group_name = var.rg_name_3
}

resource "azurerm_virtual_network_peering" "vnet1-to-vnet2" {
  #name                         = "vnet1-to-vnet2"
  #resource_group_name          = "az700-rg01"
  name                         = var.vnet1-to-vnet2-peering-name
  resource_group_name          = var.rg_name_1
  virtual_network_name         = var.vnet1_name
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "vnet2-to-vnet1" {
  # name                         = "vnet2-to-vnet1"
  # resource_group_name          = "az700-rg02"
  name                         = var.vnet2-to-vnet1-peering-name
  resource_group_name          = var.rg_name_2
  virtual_network_name         = var.vnet2_name
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "vnet1-to-vnet3" {
  # name                         = "vnet1-to-vnet3"
  # resource_group_name          = "az700-rg01"
  name                         = var.vnet1-to-vnet3-peering-name
  resource_group_name          = var.rg_name_1
  virtual_network_name         = var.vnet1_name
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet3.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "vnet3-to-vnet1" {
  # name                         = "vnet3-to-vnet1"
  # resource_group_name          = "az700-rg03"
  name                         = var.vnet3-to-vnet1-peering-name
  resource_group_name          = var.rg_name_3
  virtual_network_name         = var.vnet3_name
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
}