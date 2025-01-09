variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "webapp_name" {
  description = "The name of the Web App"
  type        = string
}

variable "app_service_plan_sku" {
  description = "The SKU of the App Service Plan"
  type        = string
}

variable "user_data_script_path" {
  description = "The path to the user data script"
  type        = string
}

variable "azure_devops_organization" {
  description = "The name of the Azure DevOps organization."
  type        = string
}

variable "project_name" {
  description = "The name of the Azure DevOps project."
  type        = string
  default     = "Test"
}

variable "agent_pool_name" {
  description = "The name of the Azure DevOps agent pool."
  type        = string
  default     = "test-pool"
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

variable "repository_name" {
  description = "The name of the repository."
  type        = string
}

variable "azurerm_vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "azurerm_subnet_name" {
  description = "The name of the subnet."
  type        = string

}

variable "azurerm_public_ip_name" {
  description = "The name of the public IP address."
  type        = string
}

variable "azurerm_network_interface_name" {
  description = "The name of the network interface."
  type        = string

}

variable "azurerm_network_security_group_name" {
  description = "The name of the network security group."
  type        = string

}

variable "azurerm_vm_admin_username" {
  description = "The username for the virtual machine."
  type        = string
  default     = "azureuser"

}

variable "azurerm_vm_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_DS2_v2"

}

variable "azurerm_computer_name" {
  description = "The name of the virtual machine."
  type        = string
  default     = "devopsdemovm"

}

variable "azurerm_linux_vm_name" {
  description = "The name of the virtual machine."
  type        = string
  default     = "DevOps_Agent_VM"

}

variable "resource_suffix" {
  description = "The suffix to append to resource names."
  type        = string
  default     = "First_Project"
}