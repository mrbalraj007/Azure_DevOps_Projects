data "azurerm_resource_group" "rg1" {
  name = var.rg_name_1 #"localNetworkGWTest"
  #location = var.gateway_location #"West Europe"
}

resource "azurerm_local_network_gateway" "home" {
  name                = var.lng_name #"local-gw"
  resource_group_name = data.azurerm_resource_group.rg1.name
  location            = data.azurerm_resource_group.rg1.location
  gateway_address     = var.local_pc-gateway_address #"61.69.158.197" # define public IP address
  address_space       = var.local_pc-address_space   #["192.168.1.0/24"]
  depends_on          = [azurerm_virtual_network_gateway.vnet_gateway]
}