output "gateway_public_ip" {
  description = "The public IP address of the virtual network gateway"
  value       = azurerm_public_ip.gateway_public_ip.ip_address
}

output "gateway_subnet_id" {
  description = "The ID of the gateway subnet"
  value       = azurerm_subnet.gateway_subnet.name
}

output "virtual_network_gateway_id" {
  description = "The ID of the virtual network gateway"
  value       = azurerm_virtual_network_gateway.vnet_gateway.name
}

output "local_network_gateway_id" {
  description = "The ID of the local network gateway"
  value       = azurerm_local_network_gateway.home.name
}

output "site_to_site_connection_id" {
  description = "The ID of the site-to-site connection"
  value       = azurerm_virtual_network_gateway_connection.site_to_site_connection.name
}
