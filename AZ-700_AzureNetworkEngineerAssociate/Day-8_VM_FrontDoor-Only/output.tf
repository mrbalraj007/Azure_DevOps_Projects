output "resource_group_name_01" {
  value = var.resource_group_name_01
}

output "location_01" {
  value = var.location_01
}

output "location_02" {
  value = var.location_02
}

output "vm_centralindia_name" {
  value = azurerm_windows_virtual_machine.rg01_vm-centralindia.name
}

output "vm_eastus_name" {
  value = azurerm_windows_virtual_machine.rg01_vm-eastus.name
}

output "vm_centralindia_public_ip" {
  value = azurerm_public_ip.rg01_public_ip-centralindia.ip_address
}

output "vm_eastus_public_ip" {
  value = azurerm_public_ip.rg01_public_ip-eastus.ip_address
}

output "vm_centralindia_fqdn" {
  value = azurerm_public_ip.rg01_public_ip-centralindia.fqdn
}

output "vm_eastus_fqdn" {
  value = azurerm_public_ip.rg01_public_ip-eastus.fqdn
}

