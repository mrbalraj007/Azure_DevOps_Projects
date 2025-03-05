# Resource Group Variables
variable "resource_group_name_01" {
  description = "The name of the resource group"
  type        = string
}

# Location Variables
variable "location_01" {
  description = "The primary location of the resources (East US)"
  type        = string
}

variable "location_02" {
  description = "The secondary location of the resources (West US)"
  type        = string
}

# VM Configuration Variables
variable "size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the virtual machine"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
  type        = string
  sensitive   = true
}

variable "agent_vm_name" {
  description = "The base name for the virtual machine"
  type        = string
}

variable "sku" {
  description = "The SKU of the virtual machine image"
  type        = string
}

variable "vm_storage_account_type" {
  description = "The storage account type for VM OS disks"
  type        = string
}

# Network Variables
variable "eastus_address_space" {
  description = "Address space for East US VNet"
  type        = list(string)
}

variable "westus_address_space" {
  description = "Address space for West US VNet"
  type        = list(string)
}

variable "eastus_public_subnet_prefix" {
  description = "CIDR prefix for East US public subnet"
  type        = string
}

variable "eastus_private_subnet_prefix" {
  description = "CIDR prefix for East US private subnet"
  type        = string
}

variable "westus_public_subnet_prefix" {
  description = "CIDR prefix for West US public subnet"
  type        = string
}

variable "eastus_public_subnet_name" {
  description = "Name for East US public subnet"
  type        = string
}

variable "eastus_private_subnet_name" {
  description = "Name for East US private subnet"
  type        = string
}

variable "westus_public_subnet_name" {
  description = "Name for West US public subnet"
  type        = string
}

# Security Variables
variable "allowed_ports" {
  description = "List of allowed ports in security groups"
  type        = list(string)
}

# Public IP Variables
variable "name_rg01_public-eastus" {
  description = "The name of the subnet for the virtual network"
  type        = string
}

variable "name_rg01_public-westus" {
  description = "The name of the subnet for the virtual network"
  type        = string
}

variable "name_rg01_public_ip1-eastus" {
  description = "Name of the public IP for VM1 in East US"
  type        = string
}

variable "name_rg01_public_ip2-eastus" {
  description = "Name of the public IP for VM2 in East US"
  type        = string
}

variable "name_rg01_public_ip-westus" {
  description = "Name of the public IP for VM in West US"
  type        = string
}

variable "dns_label_prefix_eastus1" {
  description = "DNS label prefix for East US VM1"
  type        = string
}

variable "dns_label_prefix_eastus2" {
  description = "DNS label prefix for East US VM2"
  type        = string
}

variable "dns_label_prefix_westus" {
  description = "DNS label prefix for West US VM"
  type        = string
}

# Network Interface Variables
variable "name_rg01_nic1-eastus" {
  description = "Name of the network interface for VM1 in East US"
  type        = string
}

variable "name_rg01_nic2-eastus" {
  description = "Name of the network interface for VM2 in East US"
  type        = string
}

variable "name_rg01_nic-westus" {
  description = "Name of the network interface for VM in West US"
  type        = string
}

# VM Name Variables
variable "name_rg01_vm1-eastus" {
  description = "Name of VM1 in East US"
  type        = string
}

variable "name_rg01_vm2-eastus" {
  description = "Name of VM2 in East US"
  type        = string
}

variable "name_rg01_vm-westus" {
  description = "Name of VM in West US"
  type        = string
}

# NSG Variables
variable "name_az700-rg01-sg-eastus" {
  description = "The name of the network security group for East US"
  type        = string
}

variable "name_az700-rg01-sg-westus" {
  description = "The name of the network security group for West US"
  type        = string
}

# VNet Variables
variable "name_az700-rg01-eastus-vnet-01" {
  description = "The name of the East US virtual network"
  type        = string
}

variable "name_az700-rg01-westus-vnet-01" {
  description = "The name of the West US virtual network"
  type        = string
}

# VM Extension Variables
variable "vm1_extension_name" {
  description = "Name for VM1's extension"
  type        = string
}

variable "vm2_extension_name" {
  description = "Name for VM2's extension"
  type        = string
}

variable "vm_westus_extension_name" {
  description = "Name for West US VM's extension"
  type        = string
}

# Traffic Manager Variables
variable "traffic_manager_profile_name" {
  description = "The name of the Traffic Manager profile"
  type        = string
  default     = "az700-traffic-manager-profile"
}

variable "traffic_manager_dns_name" {
  description = "The DNS name for the Traffic Manager profile"
  type        = string
  default     = "az700-traffic-manager"
}

variable "traffic_manager_routing_method" {
  description = "Routing method for the performance traffic manager"
  type        = string
}

variable "priority_traffic_manager_routing_method" {
  description = "Routing method for the priority traffic manager"
  type        = string
}

variable "traffic_manager_ttl" {
  description = "TTL value for traffic manager DNS"
  type        = number
}

variable "monitor_protocol" {
  description = "Protocol used for monitoring endpoints"
  type        = string
}

variable "monitor_port" {
  description = "Port used for monitoring endpoints"
  type        = number
}

variable "monitor_path" {
  description = "Path used for monitoring endpoints"
  type        = string
}

variable "monitor_interval" {
  description = "Interval in seconds between monitoring checks"
  type        = number
}

variable "monitor_timeout" {
  description = "Timeout in seconds for monitoring checks"
  type        = number
}

variable "monitor_tolerated_failures" {
  description = "Number of failures tolerated before endpoint is marked as down"
  type        = number
}