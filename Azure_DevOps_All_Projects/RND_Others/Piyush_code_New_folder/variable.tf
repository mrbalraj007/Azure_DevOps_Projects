variable "regname" {
  type        = string
  description = "resource group Name"
}

variable "location" {
  type        = string
  default     = "West US 2"
  description = "Location of the resource group."
}

variable "service_principal_name" {
  type        = string
  description = "Name of the service principal"

}

variable "keyvault_name" {
  type        = string
  description = "Name of the Key Vault"

}