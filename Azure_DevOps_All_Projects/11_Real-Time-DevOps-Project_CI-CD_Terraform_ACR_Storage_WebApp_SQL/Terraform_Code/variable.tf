variable "azure_devops_organization" {
  description = "The name of the Azure DevOps organization."
  type        = string
}

variable "servicePrincipalId" {
  description = "The service principal ID."
  type        = string
}

variable "servicePrincipalKey" {
  description = "The service principal key."
  type        = string
}

variable "tenantid" {
  description = "The tenant ID."
  type        = string
}

# variable "agent_pool_name" {
#   description = "The name of the Azure DevOps agent pool."
#   type        = string
#   default     = "test-pool"
# }

variable "repository_name" {
  description = "The name of the repository."
  type        = string
}

variable "repository_name1" {
  description = "The name of the second repository."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "azure_sp_object_id" {
  description = "Service Principal Object ID details"
  type        = string
}

variable "project_name" {
  description = "The name of the Azure DevOps project."
  type        = string
  default     = "Test"
}

variable "azure_devops_pat" {
  description = "The personal access token for Azure DevOps."
  type        = string
  sensitive   = true
}

variable "source_url" {
  description = "The URL of the source repository to import."
  type        = string
}

variable "source_url1" {
  description = "The URL of the source repository to import."
  type        = string
}

variable "random_string_length" {
  description = "The length of the random string to append to the Key Vault name."
  type        = number
  default     = 8
}

variable "resource_suffix" {
  description = "The suffix to append to resource names."
  type        = string
  default     = "First_Project"
}

variable "key_vault_name" {
  type = string
}

variable "ACR_ADDRESS_SPACE" {
  type = string
}

variable "ACR_SUBNET_ADDRESS_PREFIX" {
  type = string
}

variable "ACR_SUBNET_NAME" {
  type = string
}

variable "ACR_VNET_NAME" {
  type = string
}
variable "AGENT_ADDRESS_SPACE" {
  type = string
}
variable "AGENT_SUBNET_ADDRESS_PREFIX" {
  type = string
}
variable "AGENT_SUBNET_NAME" {
  type = string
}
variable "AGENT_VNET_NAME" {
  type = string
}
variable "AKS_ADDRESS_SPACE" {
  type = string
}

variable "AKS_SUBNET_ADDRESS_PREFIX" {
  type = string
}

variable "AKS_SUBNET_NAME" {
  type = string
}

variable "AKS_VNET_NAME" {
  type = string
}

variable "APPGW_SUBNET_ADDRESS_PREFIX" {
  type = string
}

variable "APPGW_SUBNET_NAME" {
  type = string
}

variable "ADMIN_USERNAME" {
  type = string
}

variable "AGENT_VM_NAME" {
  type = string
}

variable "ADMIN_PASSWORD" {
  type = string
}

variable "VM_SIZE" {
  type = string
}

variable "APP_GATEWAY_NAME" {
  type = string
}

variable "APPGW_PUBLIC_IP_NAME" {
  type = string
}

variable "VIRTUAL_NETWORK_NAME" {
  type = string
}

variable "ACR_SKU" {
  type = string
}
variable "PRIVATE_ACR_NAME" {
  type = string
}

variable "AKS_DNS_PREFIX" {
  type = string
}
variable "AKS_NAME" {
  type = string
}
variable "AKS_SSH_PUBLIC_KEY" {
  type = string
}

variable "DB_COLLATION" {
  type = string
}
variable "DB_NAME" {
  type = string
}

variable "DBPASSWORD" {
  type = string
}

variable "DBSERVER_NAME" {
  type = string
}

variable "DBUSERNAME" {
  type = string
}

variable "VNETRULE" {
  type = string
}
variable "SUBSCRIPTION_ID" {
  type = string
}