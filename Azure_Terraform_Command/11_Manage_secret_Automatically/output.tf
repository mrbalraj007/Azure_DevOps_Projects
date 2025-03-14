output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "key_vault_name" {
  value = azurerm_key_vault.example.name
}

output "instance_ip_addr" {
  value = azurerm_linux_virtual_machine.example.public_ip_addresses
}

output "instance_name" {
  value = azurerm_linux_virtual_machine.example.name
}