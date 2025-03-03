resource "azurerm_virtual_network_gateway_connection" "vnet1_to_vnet3_connection" {
  name                = var.vnet1-to-vnet3-connection-name # "vnet1-to-vnet3-connection"
  location            = var.gateway_location
  resource_group_name = var.rg_name_1

  type                            = var.connection_type #"Vnet2Vnet"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vnet_gateway.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.vnet_gateway1.id

  connection_protocol = var.connection_protocol #"IKEv2"
  shared_key          = var.shared_key          #"4-v3ry-53cr37-1p53c-5h4r3d-k3y"

  depends_on = [
    azurerm_virtual_network_gateway.vnet_gateway,
    azurerm_virtual_network_gateway.vnet_gateway1
  ]
}

resource "azurerm_virtual_network_gateway_connection" "vnet3_to_vnet1_connection" {
  name                = var.vnet3-to-vnet1-connection-name #"vnet3-to-vnet1-connection"
  location            = var.gateway_location1
  resource_group_name = var.rg_name_3

  type                            = var.connection_type #"Vnet2Vnet"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vnet_gateway1.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.vnet_gateway.id

  connection_protocol = var.connection_protocol #"IKEv2"
  shared_key          = var.shared_key          #"4-v3ry-53cr37-1p53c-5h4r3d-k3y"


  depends_on = [
    azurerm_virtual_network_gateway.vnet_gateway1,
    azurerm_virtual_network_gateway.vnet_gateway
  ]
}