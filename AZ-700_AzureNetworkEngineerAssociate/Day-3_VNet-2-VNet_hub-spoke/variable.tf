
variable "vnet1_name" {
  description = "The name of the resource group"
  type        = string
}

# variable "vnet2_name" {
#   description = "The name of the resource group"
#   type        = string
# }

variable "vnet3_name" {
  description = "The name of the resource group"
  type        = string
}

variable "rg_name_1" {
  description = "The name of the resource group"
  type        = string
}

# variable "rg_name_2" {
#   description = "The name of the resource group"
#   type        = string
# }

variable "rg_name_3" {
  description = "The name of the resource group"
  type        = string
}

# variable "vnet1-to-vnet2-peering-name" {
#   description = "The name of the peering"
#   type        = string
# }

# variable "vnet2-to-vnet1-peering-name" {
#   description = "The name of the peering"
#   type        = string
# }

# variable "vnet1-to-vnet3-peering-name" {
#   description = "The name of the peering"
#   type        = string
# }

# variable "vnet3-to-vnet1-peering-name" {
#   description = "The name of the peering"
#   type        = string
# }

# List of Virtual Network Gateway
variable "gateway_location" {
  description = "The name of gateway location"
  type        = string
}
variable "gateway_location1" {
  description = "The name of gateway location"
  type        = string
}
variable "az700-rg1-gateway-pip" {
  description = "The name of gateway Public IP"
  type        = string
}
variable "az700-rg3-gateway-pip" {
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

variable "az700-rg3-gateway-name" {
  description = "The name of gateway name"
  type        = string
}

# List of Virtual Network Gateway Connections
variable "vnet1-to-vnet3-connection-name" {
  description = "The name of vnet1-to-vnet3-connection"
  type        = string
}

variable "vnet3-to-vnet1-connection-name" {
  description = "The name of vnet3-to-vnet1-connection"
  type        = string
}


variable "connection_type" {
  description = "The name of the type"
  type        = string
}

variable "connection_protocol" {
  description = "The name of the connection protocol"
  type        = string
}

variable "shared_key" {
  description = "The name of the shared key"
  type        = string
}
