# For vnet1_name = "az700-rg01-vnet-01" and rg_name_1 = "az700-rg01" the following code will be generated:

data "azurerm_virtual_network" "vnet1" {
  name                = var.vnet1_name
  resource_group_name = var.rg_name_1
}

resource "azurerm_public_ip" "gateway_public_ip" {
  name                = var.az700-rg1-gateway-pip #"az700-rg1-gateway-01-pip"
  location            = var.gateway_location      #"eastus"
  resource_group_name = var.rg_name_1
  allocation_method   = var.allocation_method #"Static"
  sku                 = var.sku               #"Standard"
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = var.gateway-subnet-name #"GatewaySubnet"
  resource_group_name  = var.rg_name_1
  virtual_network_name = var.vnet1_name
  address_prefixes     = ["10.1.2.0/27"]
}

resource "azurerm_virtual_network_gateway" "vnet_gateway" {
  name                = var.az700-rg1-gateway-name #"az700-rg1-gateway-01"
  location            = var.gateway_location       #"eastus"
  resource_group_name = var.rg_name_1

  type          = "Vpn"
  vpn_type      = "RouteBased"
  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  #generation = 1

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.gateway_public_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }
}
