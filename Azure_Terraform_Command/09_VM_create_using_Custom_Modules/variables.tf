variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  type        = string

}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string

}

variable "public_ip_name" {
  description = "The name of the public IP"
  type        = string

}

variable "virtual_machine_name" {
  description = "The name of the virtual machine"
  type        = string

}

variable "location" {
  description = "The location of the resources"
  type        = string
}