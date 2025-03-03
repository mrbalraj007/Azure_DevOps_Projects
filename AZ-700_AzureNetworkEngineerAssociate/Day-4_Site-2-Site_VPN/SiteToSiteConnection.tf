resource "azurerm_virtual_network_gateway_connection" "site_to_site_connection" {
  name                = var.site_to_site_connection_name
  location            = var.gateway_location
  resource_group_name = var.rg_name_1

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vnet_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.home.id
  connection_protocol        = "IKEv2"
  shared_key                 = var.shared_key

  #   ipsec_policy {
  #     sa_lifetime_sec             = 3600
  #     sa_data_size_kb             = 102400000
  #     ipsec_encryption            = "AES256"
  #     ipsec_integrity             = "SHA256"
  #     ike_encryption              = "AES256"
  #     ike_integrity               = "SHA256"
  #     dh_group                    = "DHGroup14"
  #     pfs_group                   = "PFS2"
  #   }

  depends_on = [
    azurerm_virtual_network_gateway.vnet_gateway,
    azurerm_local_network_gateway.home
  ]
}
