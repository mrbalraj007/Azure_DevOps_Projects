# Azure Firewall configuration

# Public IP for Azure Firewall
resource "azurerm_public_ip" "fw_public_ip" {
  name                = var.firewall_public_ip_name
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = "Static"
  sku                 = "Standard"

  depends_on = [
    azurerm_virtual_network.vnet1,
    azurerm_windows_virtual_machine.rg01_vm-centralindia,
    azurerm_windows_virtual_machine.rg01_vm-centralindia-private,
    azurerm_windows_virtual_machine.rg01_vm-centralindia-nva
  ]
}

# Azure Firewall Policy
resource "azurerm_firewall_policy" "fw_policy" {
  name                = var.firewall_policy_name
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name

  depends_on = [
    azurerm_public_ip.fw_public_ip
  ]
}

# Network rule collection group
resource "azurerm_firewall_policy_rule_collection_group" "network_rules" {
  name               = var.firewall_network_rule_collection_group_name
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = var.firewall_network_rules_priority

  network_rule_collection {
    name     = var.firewall_network_rule_collection_name
    priority = var.firewall_network_rule_collection_priority
    action   = var.firewall_rule_allow_action

    rule {
      name                  = var.firewall_rule_web_name
      protocols             = ["TCP"]
      source_addresses      = ["10.0.0.0/24", "10.0.1.0/24"] # Public and Private subnets
      destination_addresses = ["*"]
      destination_ports     = var.firewall_web_ports
    }

    rule {
      name                  = var.firewall_rule_dns_name
      protocols             = ["UDP"]
      source_addresses      = ["10.0.0.0/24", "10.0.1.0/24"] # Public and Private subnets
      destination_addresses = ["*"]
      destination_ports     = var.firewall_dns_ports
    }

    rule {
      name                  = var.firewall_rule_rdp_name
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"] # All subnets
      destination_ports     = ["3389"]
    }
  }

  depends_on = [
    azurerm_firewall_policy.fw_policy
  ]
}

# Application rule collection group - Simplified for troubleshooting
resource "azurerm_firewall_policy_rule_collection_group" "app_rules" {
  name               = "fw-app-rules"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 200

  application_rule_collection {
    name     = "basic-web-rules"
    priority = 100
    action   = "Allow"

    rule {
      name             = "allow-microsoft"
      source_addresses = ["10.0.0.0/16"]

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }

      destination_fqdns = ["*.microsoft.com"]
    }
  }

  depends_on = [
    azurerm_firewall_policy.fw_policy,
    azurerm_firewall_policy_rule_collection_group.network_rules
  ]
}

# Azure Firewall
resource "azurerm_firewall" "fw" {
  name                = var.firewall_name
  location            = var.location_01
  resource_group_name = azurerm_resource_group.rg01.name
  sku_name            = var.firewall_sku_name
  sku_tier            = var.firewall_sku_tier
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id

  ip_configuration {
    name                 = var.firewall_ip_config_name
    subnet_id            = "${azurerm_virtual_network.vnet1.id}/subnets/AzureFirewallSubnet"
    public_ip_address_id = azurerm_public_ip.fw_public_ip.id
  }

  depends_on = [
    azurerm_firewall_policy.fw_policy,
    azurerm_firewall_policy_rule_collection_group.network_rules,
    azurerm_firewall_policy_rule_collection_group.app_rules,
    azurerm_virtual_network.vnet1,
    azurerm_windows_virtual_machine.rg01_vm-centralindia,
    azurerm_windows_virtual_machine.rg01_vm-centralindia-private,
    azurerm_windows_virtual_machine.rg01_vm-centralindia-nva
  ]
}

# Sample Route for using the Firewall as the next hop instead of the NVA
# Uncomment and modify as needed
/*
resource "azurerm_route" "to_firewall" {
  name                   = "via-firewall"
  resource_group_name    = azurerm_resource_group.rg01.name
  route_table_name       = azurerm_route_table.udr_route_table.name
  address_prefix         = "0.0.0.0/0"  # Route all internet traffic
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration[0].private_ip_address

  depends_on = [
    azurerm_route_table.udr_route_table,
    azurerm_firewall.fw
  ]
}
*/

# Output the Azure Firewall private IP (to use in routing)
output "firewall_private_ip" {
  value = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}

output "firewall_public_ip" {
  value = azurerm_public_ip.fw_public_ip.ip_address
}
