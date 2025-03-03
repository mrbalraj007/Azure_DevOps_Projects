variable "vnet1_name" {
  description = "The name of the resource group"
  type        = string
}

variable "rg_name_1" {
  description = "The name of the resource group"
  type        = string
}

# List of Virtual Network Gateway
variable "gateway_location" {
  description = "The name of gateway location"
  type        = string
}

variable "az700-rg1-gateway-pip" {
  description = "The name of gateway Public IP"
  type        = string
}


variable "allocation_method" {
  description = "The name of gateway Public IP"
  type        = string
}

variable "sku" {
  description = "The name of gateway Public IP"
  type        = string
}

variable "gateway-subnet-name" {
  description = "The name of gateway name"
  type        = string
}

variable "az700-rg1-gateway-name" {
  description = "The name of gateway name"
  type        = string
}


# List of local network Gateway

variable "lng_name" {
  description = "The name of gateway name"
  type        = string
}

variable "local_pc-gateway_address" {
  description = "The IP address of the local network gateway"
  type        = string
}


variable "local_pc-address_space" {
  description = "The name of the type"
  type        = list(any)
}

variable "site_to_site_connection_name" {
  description = "The name of the Site-to-Site connection"
  type        = string
}

variable "shared_key" {
  description = "The shared key for the Site-to-Site connection"
  type        = string
}

