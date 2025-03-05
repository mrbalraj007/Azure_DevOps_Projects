# Resource Group Configuration
resource_group_name_01 = "az700-rg001"

# Location Configuration
location_01 = "eastus"
location_02 = "westus"

# VM Configuration
size                   = "Standard_B2s"
admin_username         = "adminuser"
admin_password         = "P@$$w0rd1234!"
agent_vm_name          = "win-vm"
sku                    = "2022-Datacenter"
vm_storage_account_type = "Standard_LRS"

# Network Configuration
eastus_address_space = ["10.1.0.0/16"]
westus_address_space = ["10.3.0.0/16"]
eastus_public_subnet_prefix = "10.1.0.0/24"
eastus_private_subnet_prefix = "10.1.1.0/24"
westus_public_subnet_prefix = "10.3.0.0/24"
eastus_public_subnet_name = "Public-az700-rg01-vnet-01"
eastus_private_subnet_name = "Private-az700-rg01-vnet-01"
westus_public_subnet_name = "Public-az700-rg02-vnet-01"

# Security Configuration
allowed_ports = ["80", "3389"]

# VM and Network Resource Names
name_rg01_public-eastus = "az700-rg01-public-eastus-vnet-01"
name_rg01_public-westus = "az700-rg01-public-westus-vnet-01"
name_rg01_public_ip1-eastus = "az700-rg01-public-eastus-ip1"
name_rg01_public_ip2-eastus = "az700-rg01-public-eastus-ip2"
name_rg01_public_ip-westus = "az700-rg01-public-westus-ip1"
name_rg01_nic1-eastus = "az700-rg01-public-eastus-nic1"
name_rg01_nic2-eastus = "az700-rg01-public-eastus-nic2"
name_rg01_nic-westus = "az700-rg01-public-westus-nic1"
name_rg01_vm1-eastus = "az700-rg01-public-eastus-vm01"
name_rg01_vm2-eastus = "az700-rg01-public-eastus-vm02"
name_rg01_vm-westus = "az700-rg01-public-westus-vm01"
name_az700-rg01-sg-eastus = "az700-rg01-sg-eastus"
name_az700-rg01-sg-westus = "az700-rg01-sg-westus"
name_az700-rg01-eastus-vnet-01 = "az700-rg01-eastus-vnet-01"
name_az700-rg01-westus-vnet-01 = "az700-rg01-westus-vnet-01"

# DNS Label Prefixes
dns_label_prefix_eastus1 = "az700-vm1-eastus"
dns_label_prefix_eastus2 = "az700-vm2-eastus"
dns_label_prefix_westus = "az700-vm-westus"

# VM Extensions
vm1_extension_name = "rg01-vm1-extension"
vm2_extension_name = "rg01-vm2-extension"
vm_westus_extension_name = "rg01-vm-westus-extension"

# Traffic Manager Configuration
traffic_manager_profile_name = "az700-tm-profile"
traffic_manager_dns_name = "az700-traffic-manager-demo"
traffic_manager_routing_method = "Performance"
priority_traffic_manager_routing_method = "Priority"
traffic_manager_ttl = 30
monitor_protocol = "HTTP"
monitor_port = 80
monitor_path = "/"
monitor_interval = 30
monitor_timeout = 10
monitor_tolerated_failures = 3