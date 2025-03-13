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

variable "centralindia_public_subnet_prefix" {
  description = "CIDR prefix for Central India public subnet"
  type        = string
}

variable "centralindia_private_subnet_prefix" {
  description = "CIDR prefix for Central India private subnet"
  type        = string
}

variable "centralindia_nva_subnet_name" {
  description = "Name for Central India NVA subnet"
  type        = string
}

variable "name_rg01_nic-centralindia-nva" {
  description = "Name of the network interface for NVA VM in Central India"
  type        = string
}

variable "name_rg01_vm-centralindia-nva" {
  description = "Name of NVA VM in Central India"
  type        = string
}

variable "vm_centralindia_nva_extension_name" {
  description = "Name for Central India NVA VM's extension"
  type        = string
}

variable "centralindia_nva_subnet_prefix" {
  description = "CIDR prefix for Central India NVA subnet"
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

variable "name_rg01_public_ip-centralindia" {
  description = "Name of the public IP for VM in Central India"
  type        = string
}

variable "dns_label_prefix_centralindia" {
  description = "DNS label prefix for Central India VM"
  type        = string
}

variable "name_rg01_public_ip-centralindia-private" {
  description = "Name of the public IP for private VM in Central India"
  type        = string
}

variable "name_rg01_public_ip-centralindia-nva" {
  description = "Name of the public IP for NVA VM in Central India"
  type        = string
}

variable "dns_label_prefix_centralindia_private" {
  description = "DNS label prefix for Central India Private VM"
  type        = string
}

variable "dns_label_prefix_centralindia_nva" {
  description = "DNS label prefix for Central India NVA VM"
  type        = string
}

# Network Interface Variables
variable "name_rg01_nic-centralindia" {
  description = "Name of the network interface for VM in Central India"
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

# VNet Variables
variable "name_az700-rg01-centralindia-vnet-01" {
  description = "The name of the Central India virtual network"
  type        = string
}

# VM Extension Variables
variable "vm_centralindia_extension_name" {
  description = "Name for Central India VM's extension"
  type        = string
}

# Private VM Extension Variables
variable "vm_centralindia_private_extension_name" {
  description = "Name for Central India private VM's extension"
  type        = string
}

# Route Table Variables
variable "route_table_name" {
  description = "Name of the route table"
  type        = string
}

variable "route_name_to_nva" {
  description = "Name of the route to NVA"
  type        = string
}

variable "route_address_prefix" {
  description = "Address prefix for the route"
  type        = string
}

variable "next_hop_type" {
  description = "Type of next hop"
  type        = string
}

# Tag Variables
variable "tag_environment_route_table" {
  description = "Environment tag for route table"
  type        = string
}

variable "tag_environment_vnet" {
  description = "Environment tag for virtual network"
  type        = string
}

# VM Extension Configurations
variable "web_page_content_public" {
  description = "HTML content for the public VM web page"
  type        = string
}

variable "web_page_content_private" {
  description = "HTML content for the private VM web page"
  type        = string
}

variable "web_page_content_nva" {
  description = "HTML content for the NVA VM web page"
  type        = string
}