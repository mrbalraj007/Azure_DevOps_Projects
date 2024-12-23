output "instance_ip_addr" {
  value = azurerm_linux_virtual_machine.example.public_ip_addresses
}

output "instance_name" {
  value = azurerm_linux_virtual_machine.example.name
}

output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.example.name
}

output "subnet_name" {
  value = azurerm_subnet.example.name
}

output "public_ip_address" {
  value = azurerm_public_ip.example.ip_address
}

output "network_interface_id" {
  value = azurerm_network_interface.example.id
}

output "network_security_group_id" {
  value = azurerm_network_security_group.example.id
}

output "linux_virtual_machine_id" {
  value = azurerm_linux_virtual_machine.example.id
}

output "linux_virtual_machine_private_ip" {
  value = azurerm_network_interface.example.private_ip_address
}

output "container_registry_name" {
  value = azurerm_container_registry.example.name
}