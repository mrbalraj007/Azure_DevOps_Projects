# # # output "agent_pool_name" {
# # #   value = var.agent_pool_name
# # # }

output "repository_name" {
  value = var.repository_name
}

output "resource_group_name" {
  value = var.resource_group_name
}

output "location" {
  value = var.location
}

output "project_name" {
  value = var.project_name
}

output "azure_rm_service_connection_name" {
  value = var.azure_rm_service_connection_name
}

output "azuredevops_serviceendpoint_aws" {
  value = var.aws_service_connection_name
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
