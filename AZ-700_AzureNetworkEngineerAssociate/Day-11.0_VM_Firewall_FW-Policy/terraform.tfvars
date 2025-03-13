# Resource Group Configuration
resource_group_name_01 = "udr-rg"

# Location Configuration
location_01 = "centralindia"

# VM Configuration
size                    = "Standard_B2s"
admin_username          = "adminuser"
admin_password          = "P@$$w0rd1234!"
agent_vm_name           = "vm"
sku                     = "2022-Datacenter"
vm_storage_account_type = "Standard_LRS"

# Network Configuration
centralindia_address_space          = ["10.0.0.0/16"]
centralindia_public_subnet_prefix   = "10.0.0.0/24"
centralindia_private_subnet_prefix  = "10.0.1.0/24"
centralindia_nva_subnet_prefix      = "10.0.2.0/24"
centralindia_firewall_subnet_prefix = "10.0.3.0/24"
centralindia_bastion_subnet_prefix  = "10.0.4.0/24"
centralindia_nva_subnet_name        = "NVA-centralindia-vnet"
centralindia_public_subnet_name     = "Public-centralindia-vnet"
centralindia_private_subnet_name    = "Private-centralindia-vnet"

# Security Configuration
allowed_ports = ["80", "3389"]

# VM and Network Resource Names
name_rg01_public-centralindia        = "public-centralindia-vnet-01"
name_rg01_public_ip-centralindia     = "public-centralindia-ip"
name_rg01_nic-centralindia           = "public-centralindia-nic"
name_rg01_vm-centralindia            = "public-centralindia-vm"
name_az700-rg01-sg-centralindia      = "sg-centralindia"
name_az700-rg01-centralindia-vnet-01 = "centralindia-vnet-01"

# Private VM Resources
name_rg01_nic-centralindia-private     = "private-centralindia-nic"
name_rg01_vm-centralindia-private      = "private-centralindia-vm"
vm_centralindia_private_extension_name = "rg01-vm-centralindia-private-extension"

# NVA VM Resources
name_rg01_nic-centralindia-nva     = "nva-centralindia-nic"
name_rg01_vm-centralindia-nva      = "nva-centralindia-vm"
vm_centralindia_nva_extension_name = "rg01-vm-centralindia-nva-extension"

# Public IP names for private and NVA VMs
name_rg01_public_ip-centralindia-private = "private-centralindia-ip"
name_rg01_public_ip-centralindia-nva     = "nva-centralindia-ip"

# DNS Label Prefixes
dns_label_prefix_centralindia         = "az700-vm-centralindia"
dns_label_prefix_centralindia_private = "az700-vm-centralindia-private"
dns_label_prefix_centralindia_nva     = "az700-vm-centralindia-nva"

# VM Extensions
vm_centralindia_extension_name = "rg01-vm-centralindia-extension"

# Route Table Configuration
route_table_name     = "fw-rt"
route_name_to_nva    = "trafficetointernet"
route_address_prefix = "0.0.0.0/0" # Private subnet address prefix or 0.0.0.0/0 for all traffic
next_hop_type        = "VirtualAppliance"

# Tag Values
tag_environment_route_table = "az700-udr-route-table"
tag_environment_vnet        = "az700-rg01-centralindia-env"

# VM Extension Configurations
web_page_content_public  = "<html><body><h1>This is the Central India server</h1></body></html>"
web_page_content_private = "<html><body><h1>This is the Private Central India server</h1></body></html>"
web_page_content_nva     = "<html><body><h1>This is the NVA in Central India</h1></body></html>"

# Firewall Configuration
firewall_name                               = "azure-firewall"
firewall_public_ip_name                     = "azure-firewall-ip"
firewall_policy_name                        = "azure-fw-policy"
firewall_ip_config_name                     = "fw-ip-configuration"
firewall_sku_name                           = "AZFW_VNet"
firewall_sku_tier                           = "Standard"
firewall_network_rule_collection_group_name = "fw-network-rules"
firewall_app_rule_collection_group_name     = "fw-app-rules"
firewall_network_rule_collection_name       = "allow-outbound"
firewall_app_rule_collection_name           = "allow-web-services"
firewall_rule_web_name                      = "allow-web"
firewall_rule_dns_name                      = "allow-dns"
firewall_rule_rdp_name                      = "allow-rdp"
firewall_rule_ms_services_name              = "allow-microsoft-services"
firewall_rule_azure_services_name           = "allow-azure-services"
firewall_network_rules_priority             = 100
firewall_app_rules_priority                 = 200
firewall_network_rule_collection_priority   = 100
firewall_app_rule_collection_priority       = 100
firewall_rule_allow_action                  = "Allow"
firewall_web_ports                          = ["80", "443"]
firewall_dns_ports                          = ["53"]
route_name_to_firewall                      = "traffic-to-internet-via-firewall"
microsoft_fqdn_tags                         = ["WindowsUpdate", "MicrosoftActiveProtectionService", "google"]
microsoft_service_fqdns                     = ["*.microsoft.com", "*.windowsupdate.com", "*.google.com"]