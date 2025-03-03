
variable "vnet1_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vnet2_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vnet3_name" {
  description = "The name of the resource group"
  type        = string
}

variable "rg_name_1" {
  description = "The name of the resource group"
  type        = string
}

variable "rg_name_2" {
  description = "The name of the resource group"
  type        = string
}

variable "rg_name_3" {
  description = "The name of the resource group"
  type        = string
}

variable "vnet1-to-vnet2-peering-name" {
  description = "The name of the peering"
  type        = string
}

variable "vnet2-to-vnet1-peering-name" {
  description = "The name of the peering"
  type        = string
}

variable "vnet1-to-vnet3-peering-name" {
  description = "The name of the peering"
  type        = string
}

variable "vnet3-to-vnet1-peering-name" {
  description = "The name of the peering"
  type        = string
}