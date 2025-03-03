output "gateway_public_ip" {
  description = "The public IP address of the virtual network gateway"
  value       = azurerm_public_ip.gateway_public_ip.ip_address
}

output "gateway_subnet_id" {
  description = "The ID of the gateway subnet"
  value       = azurerm_subnet.gateway_subnet.id
}

output "virtual_network_gateway_id" {
  description = "The ID of the virtual network gateway"
  value       = azurerm_virtual_network_gateway.vnet_gateway.id
}

output "gateway_public_ip1" {
  description = "The public IP address of the second virtual network gateway"
  value       = azurerm_public_ip.gateway_public_ip1.ip_address
}

output "gateway_subnet1_id" {
  description = "The ID of the second gateway subnet"
  value       = azurerm_subnet.gateway_subnet1.id
}

output "virtual_network_gateway1_id" {
  description = "The ID of the second virtual network gateway"
  value       = azurerm_virtual_network_gateway.vnet_gateway1.id
}

output "vnet1_to_vnet3_connection_id" {
  description = "The ID of the VNet-to-VNet connection from vnet1 to vnet3"
  value       = azurerm_virtual_network_gateway_connection.vnet1_to_vnet3_connection.id
}

output "vnet3_to_vnet1_connection_id" {
  description = "The ID of the VNet-to-VNet connection from vnet3 to vnet1"
  value       = azurerm_virtual_network_gateway_connection.vnet3_to_vnet1_connection.id
}
