output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet_name" {
  value = azurerm_subnet.subnet.name
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "private_ip_address" {
  value = azurerm_network_interface.nic.private_ip_address
}

output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}

# output "webapp_name" {
#   value = azurerm_linux_web_app.app.name
# }

output "admin_username" {
  value = azurerm_linux_virtual_machine.vm.admin_username
}

output "agent_pool_name" {
  value = var.agent_pool_name
}

output "project_name" {
  value = var.project_name
}

# output "resource_group_name" {
#   value = azurerm_resource_group.example.name
# }

output "storage_account_name" {
  value = azurerm_storage_account.str-acct.name
}

output "storage_container_name" {
  value = azurerm_storage_container.str-container.name
}
