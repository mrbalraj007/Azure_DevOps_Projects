# Resource Group Variables
variable "resource_group_name_01" {
  description = "The name of the resource group"
  type        = string
}

# Location Variables
variable "location_01" {
  description = "The primary location of the resources (Central India)"
  type        = string
}

variable "location_02" {
  description = "The secondary location of the resources (East US)"
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
variable "centralindia_address_space" {
  description = "Address space for Central India VNet"
  type        = list(string)
}

variable "eastus_address_space" {
  description = "Address space for East US VNet"
  type        = list(string)
}

variable "centralindia_public_subnet_prefix" {
  description = "CIDR prefix for Central India public subnet"
  type        = string
}

variable "centralindia_private_subnet_prefix" {
  description = "CIDR prefix for Central India private subnet"
  type        = string
}

variable "eastus_public_subnet_prefix" {
  description = "CIDR prefix for East US public subnet"
  type        = string
}

variable "eastus_private_subnet_prefix" {
  description = "CIDR prefix for East US private subnet"
  type        = string
}

variable "centralindia_public_subnet_name" {
  description = "Name for Central India public subnet"
  type        = string
}

variable "centralindia_private_subnet_name" {
  description = "Name for Central India private subnet"
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

# Security Variables
variable "allowed_ports" {
  description = "List of allowed ports in security groups"
  type        = list(string)
}

# Public IP Variables
variable "name_rg01_public-centralindia" {
  description = "The name of the subnet for the Central India virtual network"
  type        = string
}

variable "name_rg01_public-eastus" {
  description = "The name of the subnet for the East US virtual network"
  type        = string
}

variable "name_rg01_public_ip-centralindia" {
  description = "Name of the public IP for VM in Central India"
  type        = string
}

variable "name_rg01_public_ip-eastus" {
  description = "Name of the public IP for VM in East US"
  type        = string
}

variable "dns_label_prefix_centralindia" {
  description = "DNS label prefix for Central India VM"
  type        = string
}

variable "dns_label_prefix_eastus" {
  description = "DNS label prefix for East US VM"
  type        = string
}

# Network Interface Variables
variable "name_rg01_nic-centralindia" {
  description = "Name of the network interface for VM in Central India"
  type        = string
}

variable "name_rg01_nic-eastus" {
  description = "Name of the network interface for VM in East US"
  type        = string
}

# Private VM Network Interface Variables
variable "name_rg01_nic-centralindia-private" {
  description = "Name of the network interface for private VM in Central India"
  type        = string
}

# VM Name Variables
variable "name_rg01_vm-centralindia" {
  description = "Name of VM in Central India"
  type        = string
}

variable "name_rg01_vm-eastus" {
  description = "Name of VM in East US"
  type        = string
}

# Private VM Name Variables
variable "name_rg01_vm-centralindia-private" {
  description = "Name of private VM in Central India"
  type        = string
}

# NSG Variables
variable "name_az700-rg01-sg-centralindia" {
  description = "The name of the network security group for Central India"
  type        = string
}

variable "name_az700-rg01-sg-eastus" {
  description = "The name of the network security group for East US"
  type        = string
}

# VNet Variables
variable "name_az700-rg01-centralindia-vnet-01" {
  description = "The name of the Central India virtual network"
  type        = string
}

variable "name_az700-rg01-eastus-vnet-01" {
  description = "The name of the East US virtual network"
  type        = string
}

# VM Extension Variables
variable "vm_centralindia_extension_name" {
  description = "Name for Central India VM's extension"
  type        = string
}

variable "vm_eastus_extension_name" {
  description = "Name for East US VM's extension"
  type        = string
}

# Private VM Extension Variables
variable "vm_centralindia_private_extension_name" {
  description = "Name for Central India private VM's extension"
  type        = string
}

# NAT Gateway Variables
variable "natgw_public_ip_name" {
  description = "Name for the NAT Gateway public IP"
  type        = string
}

variable "nat_gateway_name" {
  description = "Name for the NAT Gateway"
  type        = string
}

variable "nat_gateway_sku" {
  description = "SKU for the NAT Gateway"
  type        = string
}

variable "nat_gateway_idle_timeout" {
  description = "Idle timeout in minutes for the NAT Gateway"
  type        = number
}

variable "natgw_public_ip_allocation" {
  description = "Allocation method for NAT Gateway public IP"
  type        = string
}

variable "natgw_public_ip_sku" {
  description = "SKU for NAT Gateway public IP"
  type        = string
}

variable "natgw_public_ip_zones" {
  description = "Availability zones for NAT Gateway public IP"
  type        = list(string)
}