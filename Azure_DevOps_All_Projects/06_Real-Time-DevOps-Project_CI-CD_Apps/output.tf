output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "service_plan_id" {
  value = azurerm_service_plan.asp.id
}

output "web_app_name" {
  value = azurerm_linux_web_app.app.name
}

output "web_app_default_hostname" {
  value = azurerm_linux_web_app.app.default_hostname
}
