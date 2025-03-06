resource "azurerm_frontdoor" "rg01_frontdoor" {
  name                = var.front_door_name
  resource_group_name = azurerm_resource_group.rg01.name

  routing_rule {
    name               = "routingRule1"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["frontendEndpoint1"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "backendPool1"
    }
  }

  backend_pool_load_balancing {
    name = "loadBalancingSettings1"
  }

  backend_pool_health_probe {
    name = "healthProbeSettings1"
  }

  backend_pool {
    name = "backendPool1"
    load_balancing_name = "loadBalancingSettings1"
    health_probe_name   = "healthProbeSettings1"

    backend {
      host_header = azurerm_public_ip.rg01_public_ip-centralindia.fqdn
      address     = azurerm_public_ip.rg01_public_ip-centralindia.fqdn
      http_port   = 80
      https_port  = 443
      priority    = 1
      weight      = 50
    }

    backend {
      host_header = azurerm_public_ip.rg01_public_ip-eastus.fqdn
      address     = azurerm_public_ip.rg01_public_ip-eastus.fqdn
      http_port   = 80
      https_port  = 443
      priority    = 1
      weight      = 50
    }
  }

  frontend_endpoint {
    name      = "frontendEndpoint1"
    host_name = "${var.front_door_name}.azurefd.net"
  }

  tags = {
    environment = "Production"
    CreatedBy   = "Terraform"
  }

  depends_on = [
    azurerm_virtual_network.vnet1,
    azurerm_virtual_network.vnet2,
    azurerm_windows_virtual_machine.rg01_vm-centralindia,
    azurerm_windows_virtual_machine.rg01_vm-eastus,
    azurerm_virtual_machine_extension.rg01_vm_centralindia_extension,
    azurerm_virtual_machine_extension.rg01_vm_eastus_extension
  ]
}

output "frontdoor_endpoint" {
  value = "${var.front_door_name}.azurefd.net"
}
