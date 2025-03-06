resource "azurerm_frontdoor_firewall_policy" "waf_policy" {
  name                = var.waf_policy_name
  resource_group_name = azurerm_resource_group.rg01.name
  enabled             = true
  mode                = var.waf_mode

  managed_rule {
    type    = "DefaultRuleSet"
    version = "1.0"
    
    override {
      rule_group_name = "SQLI"
      rule {
        rule_id = "942100"
        enabled = true
        action  = "Block"
      }
    }
  }

  custom_rule {
    name                           = "BlockCountriesRule"
    enabled                        = true
    priority                       = 100
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 10
    type                           = "MatchRule"
    action                         = "Block"

    match_condition {
      match_variable     = "RemoteAddr"
      operator           = "GeoMatch"
      negation_condition = false
      match_values       = var.waf_blocked_countries
    }
  }

  custom_rule {
    name                           = "RateLimitRule"
    enabled                        = true
    priority                       = 200
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 100
    type                           = "RateLimitRule"
    action                         = "Block"

    match_condition {
      match_variable     = "RequestUri"
      operator           = "BeginsWith"
      negation_condition = false
      match_values       = ["/"]
    }
  }

  tags = {
    environment = "Production"
    CreatedBy   = "Terraform"
  }
  
  depends_on = [
    azurerm_frontdoor.rg01_frontdoor
  ]
}

# Remove the problematic null_resource and use a reliable approach
resource "local_file" "waf_association_script" {
  content = <<-EOT
#!/bin/bash
# This script provides instructions for associating a WAF policy with Azure Front Door
# Since the Azure CLI commands for Front Door can change, below are instructions for both CLI and Portal

# Azure CLI Instructions
echo "======================= Azure CLI Instructions ======================="
echo "To associate the WAF policy with Front Door using Azure CLI, try these commands:"
echo ""
echo "# Login to Azure (if not already logged in)"
echo "az login"
echo ""
echo "# Make sure the front-door extension is installed"
echo "az extension add --name front-door"
echo ""
echo "# Try this command syntax first:"
echo "az network front-door waf-policy frontend-endpoint link create \\"
echo "  --resource-group ${azurerm_resource_group.rg01.name} \\"
echo "  --policy-name ${var.waf_policy_name} \\"
echo "  --fd-name ${var.front_door_name} \\"
echo "  --frontend-endpoint-name frontendEndpoint1"
echo ""
echo "# If that doesn't work, try this alternative syntax:"
echo "az network front-door waf-policy link \\"
echo "  --resource-group ${azurerm_resource_group.rg01.name} \\"
echo "  --policy-name ${var.waf_policy_name} \\"
echo "  --fd-name ${var.front_door_name} \\"
echo "  --frontend-endpoint frontendEndpoint1"
echo ""
echo "# If CLI commands continue to have issues, please use the Azure Portal method below"
echo ""
echo "======================= Azure Portal Instructions ======================="
echo "To associate the WAF policy with Front Door using Azure Portal:"
echo ""
echo "1. Go to the Azure Portal (https://portal.azure.com)"
echo "2. Navigate to your Front Door resource: ${var.front_door_name}"
echo "3. Click on 'Security policies' in the left menu"
echo "4. Click '+ Associate'"
echo "5. Select the WAF policy: ${var.waf_policy_name}"
echo "6. Select the frontend endpoint: frontendEndpoint1"
echo "7. Click 'Add'"
echo "8. Wait for the association to complete"
echo ""
echo "The WAF policy should now be associated with your Front Door frontend endpoint"
EOT

  filename = "${path.module}/waf_association_instructions.sh"
  file_permission = "0755"  # Make the script executable
  
  depends_on = [
    azurerm_frontdoor.rg01_frontdoor,
    azurerm_frontdoor_firewall_policy.waf_policy
  ]
}

output "waf_association_instructions" {
  value = <<-EOT
=== IMPORTANT: WAF POLICY ASSOCIATION INSTRUCTIONS ===

To associate the WAF policy with Front Door, follow the instructions in the generated script:

1. Open a terminal in VS Code or command prompt
2. Navigate to your project directory
3. Run: ./waf_association_instructions.sh
4. Follow the displayed instructions

Due to potential CLI compatibility issues, the script provides both CLI and Portal instructions.
EOT
}
