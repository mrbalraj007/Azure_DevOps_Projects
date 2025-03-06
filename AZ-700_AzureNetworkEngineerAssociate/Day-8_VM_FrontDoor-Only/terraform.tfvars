# Resource Group Configuration
resource_group_name_01 = "az700-rg001"

# Location Configuration
location_01 = "centralindia"
location_02 = "eastus"

# VM Configuration
size                    = "Standard_B2s"
admin_username          = "adminuser"
admin_password          = "P@$$w0rd1234!"
agent_vm_name           = "vm"
sku                     = "2022-Datacenter"
vm_storage_account_type = "Standard_LRS"

# Network Configuration
centralindia_address_space         = ["10.1.0.0/16"]
eastus_address_space               = ["10.3.0.0/16"]
centralindia_public_subnet_prefix  = "10.1.0.0/24"
centralindia_private_subnet_prefix = "10.1.1.0/24"
eastus_public_subnet_prefix        = "10.3.0.0/24"
eastus_private_subnet_prefix       = "10.3.1.0/24"
centralindia_public_subnet_name    = "Public-az700-rg01-centralindia-vnet"
centralindia_private_subnet_name   = "Private-az700-rg01-centralindia-vnet"
eastus_public_subnet_name          = "Public-az700-rg01-eastus-vnet"
eastus_private_subnet_name         = "Private-az700-rg01-eastus-vnet"

# Security Configuration
allowed_ports = ["80", "3389"]

# VM and Network Resource Names
name_rg01_public-centralindia        = "az700-rg01-public-centralindia-vnet-01"
name_rg01_public-eastus              = "az700-rg01-public-eastus-vnet-01"
name_rg01_public_ip-centralindia     = "az700-rg01-public-centralindia-ip"
name_rg01_public_ip-eastus           = "az700-rg01-public-eastus-ip"
name_rg01_nic-centralindia           = "az700-rg01-public-centralindia-nic"
name_rg01_nic-eastus                 = "az700-rg01-public-eastus-nic"
name_rg01_vm-centralindia            = "az700-rg01-public-centralindia-vm"
name_rg01_vm-eastus                  = "az700-rg01-public-eastus-vm"
name_az700-rg01-sg-centralindia      = "az700-rg01-sg-centralindia"
name_az700-rg01-sg-eastus            = "az700-rg01-sg-eastus"
name_az700-rg01-centralindia-vnet-01 = "az700-rg01-centralindia-vnet-01"
name_az700-rg01-eastus-vnet-01       = "az700-rg01-eastus-vnet-01"

# DNS Label Prefixes
dns_label_prefix_centralindia = "az700-vm-centralindia"
dns_label_prefix_eastus       = "az700-vm-eastus"

# VM Extensions
vm_centralindia_extension_name = "rg01-vm-centralindia-extension"
vm_eastus_extension_name       = "rg01-vm-eastus-extension"

# Front Door Configuration
front_door_name = "az700-frontdoor-demo-20250306"