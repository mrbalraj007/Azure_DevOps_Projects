output "resource_group_name_01" {
  value = var.resource_group_name_01
}

output "location_01" {
  value = var.location_01
}

output "vm1_name" {
  value = azurerm_windows_virtual_machine.rg01_vm1-eastus.name
}

output "vm2_name" {
  value = azurerm_windows_virtual_machine.rg01_vm2-eastus.name
}

output "vm_westus_name" {
  value = azurerm_windows_virtual_machine.rg01_vm-westus.name
}

