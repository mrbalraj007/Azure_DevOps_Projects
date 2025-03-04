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

output "lb_name" {
  value = azurerm_lb.rg01_lb.name
}

output "lb_backend_pool_id" {
  value = azurerm_lb_backend_address_pool.rg01_lb_backend.name
}

output "lb_probe_id" {
  value = azurerm_lb_probe.rg01_lb_probe.name
}

output "lb_rule_id" {
  value = azurerm_lb_rule.rg01_lb_rule.name
}
