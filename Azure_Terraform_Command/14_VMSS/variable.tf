variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "myfirst-demo-20012025-rg"
}

variable "location" {
  description = "The location of the resources"
  type        = string
  default     = "Australia East"
}

variable "vmss_name" {
  description = "The name of the Virtual Machine Scale Set"
  type        = string
  default     = "myfirst-demo-20012025"
}