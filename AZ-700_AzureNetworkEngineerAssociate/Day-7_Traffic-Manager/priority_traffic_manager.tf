# Priority-based Traffic Manager Profile
resource "azurerm_traffic_manager_profile" "priority_tm_profile" {
  name                   = "${var.traffic_manager_profile_name}-priority"
  resource_group_name    = azurerm_resource_group.rg01.name
  traffic_routing_method = "Priority"

  dns_config {
    relative_name = "${var.traffic_manager_dns_name}-priority"
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
    environment = "az700-priority-traffic-manager"
  }

  # Add dependency on the performance-based Traffic Manager profile
  depends_on = [
    azurerm_windows_virtual_machine.rg01_vm-westus,
    azurerm_virtual_machine_extension.rg01_vm_westus_extension,
    azurerm_traffic_manager_profile.tm_profile,
    azurerm_traffic_manager_azure_endpoint.eastus_endpoint1,
    azurerm_traffic_manager_azure_endpoint.eastus_endpoint2,
    azurerm_traffic_manager_azure_endpoint.westus_endpoint
  ]
}

# West US Endpoint (primary)
resource "azurerm_traffic_manager_azure_endpoint" "priority_westus_endpoint" {
  name               = "priority-westus-endpoint"
  profile_id         = azurerm_traffic_manager_profile.priority_tm_profile.id
  target_resource_id = azurerm_public_ip.rg01_public_ip-westus.id
  weight             = 100
  priority           = 1  # Primary endpoint - lowest priority value has highest priority
  enabled            = true

  # Add dependency on the performance-based Traffic Manager endpoints
  depends_on = [
    azurerm_windows_virtual_machine.rg01_vm-westus,
    azurerm_virtual_machine_extension.rg01_vm_westus_extension,
    azurerm_traffic_manager_azure_endpoint.westus_endpoint,
    azurerm_traffic_manager_profile.priority_tm_profile
  ]
}

# Add outputs for the priority-based Traffic Manager
output "priority_traffic_manager_profile_id" {
  value       = azurerm_traffic_manager_profile.priority_tm_profile.id
  description = "The ID of the Priority-based Traffic Manager profile"
}

output "priority_traffic_manager_fqdn" {
  value       = azurerm_traffic_manager_profile.priority_tm_profile.fqdn
  description = "The FQDN of the Priority-based Traffic Manager profile"
}

output "priority_traffic_manager_endpoint" {
  value       = azurerm_traffic_manager_azure_endpoint.priority_westus_endpoint.target_resource_id
  description = "The target resource ID of the Priority-based Traffic Manager endpoint"
}
