output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.example.name
}

output "storage_container_name" {
  value = azurerm_storage_container.example.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet_name" {
  value = azurerm_subnet.subnet.name
}

output "vmss_name" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.name
}

output "webapp_name" {
  value = azurerm_linux_web_app.app.name
}

output "app_service_plan_id" {
  value = azurerm_service_plan.asp.id
}