# Traffic Manager Profile
resource "azurerm_traffic_manager_profile" "tm_profile" {
  name                   = "${var.traffic_manager_profile_name}-performance"
  resource_group_name    = azurerm_resource_group.rg01.name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "${var.traffic_manager_dns_name}-performance"
    ttl           = 30
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 3
  }

  tags = {
    environment = "az700-performance-traffic-manager"
  }

  depends_on = [
    azurerm_windows_virtual_machine.rg01_vm1-eastus,
    azurerm_windows_virtual_machine.rg01_vm2-eastus,
    azurerm_windows_virtual_machine.rg01_vm-westus,
    azurerm_virtual_machine_extension.rg01_vm1_extension,
    azurerm_virtual_machine_extension.rg01_vm2_extension,
    azurerm_virtual_machine_extension.rg01_vm_westus_extension
  ]
}

# East US Endpoint 1 (VM1)
resource "azurerm_traffic_manager_azure_endpoint" "eastus_endpoint1" {
  name               = "eastus-endpoint1"
  profile_id         = azurerm_traffic_manager_profile.tm_profile.id
  target_resource_id = azurerm_public_ip.rg01_public_ip1-eastus.id
  weight             = 100
  priority           = 1
  enabled            = true

  depends_on = [
    azurerm_windows_virtual_machine.rg01_vm1-eastus,
    azurerm_virtual_machine_extension.rg01_vm1_extension
  ]
}

# East US Endpoint 2 (VM2)
resource "azurerm_traffic_manager_azure_endpoint" "eastus_endpoint2" {
  name               = "eastus-endpoint2"
  profile_id         = azurerm_traffic_manager_profile.tm_profile.id
  target_resource_id = azurerm_public_ip.rg01_public_ip2-eastus.id
  weight             = 100
  priority           = 2
  enabled            = true

  depends_on = [
    azurerm_windows_virtual_machine.rg01_vm2-eastus,
    azurerm_virtual_machine_extension.rg01_vm2_extension
  ]
}

# West US Endpoint
resource "azurerm_traffic_manager_azure_endpoint" "westus_endpoint" {
  name               = "westus-endpoint"
  profile_id         = azurerm_traffic_manager_profile.tm_profile.id
  target_resource_id = azurerm_public_ip.rg01_public_ip-westus.id
  weight             = 100
  priority           = 3
  enabled            = true

  depends_on = [
    azurerm_windows_virtual_machine.rg01_vm-westus,
    azurerm_virtual_machine_extension.rg01_vm_westus_extension
  ]
}

# Add Traffic Manager outputs
output "traffic_manager_profile_id" {
  value       = azurerm_traffic_manager_profile.tm_profile.id
  description = "The ID of the Traffic Manager profile"
}

output "traffic_manager_fqdn" {
  value       = azurerm_traffic_manager_profile.tm_profile.fqdn
  description = "The FQDN of the Traffic Manager profile"
}

output "traffic_manager_endpoints" {
  value = {
    "eastus_endpoint1" = azurerm_traffic_manager_azure_endpoint.eastus_endpoint1.target_resource_id
    "eastus_endpoint2" = azurerm_traffic_manager_azure_endpoint.eastus_endpoint2.target_resource_id
    "westus_endpoint"  = azurerm_traffic_manager_azure_endpoint.westus_endpoint.target_resource_id
  }
  description = "The endpoints of the Traffic Manager profile"
}
