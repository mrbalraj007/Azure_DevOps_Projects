variable "resource_group_name_01" {
  description = "The name of the resource group"
  type        = string
}
variable "location_01" {
  description = "The location of the resources"
  type        = string
}

# variable "resource_group_name_02" {
#   description = "The name of the resource group"
#   type        = string
# }

# variable "resource_group_name_03" {
#   description = "The name of the resource group"
#   type        = string
# }



# variable "location_02" {
#   description = "The location of the resources"
#   type        = string
# }
# variable "location_03" {
#   description = "The location of the resources"
#   type        = string
# }

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
  description = "The admin password for the virtual machine"
  type        = string

}


# variable "project_name" {
#   description = "The name of the Azure DevOps project."
#   type        = string
#   #default     = "Test"
# }

# variable "azure_devops_pat" {
#   description = "The personal access token for Azure DevOps."
#   type        = string
#   sensitive   = true
# }

# variable "source_url" {
#   description = "The URL of the source repository to import."
#   type        = string
# }

# variable "azure_rm_service_connection_name" {
#   description = "The name of the Azure Resource Manager service connection."
#   type        = string
# }

# variable "azure_rm_service_connection_name_aws" {
#   description = "The name of the Azure Resource Manager service connection."
#   type        = string
# }

# variable "azure_subscription_id" {
#   description = "The ID of the Azure subscription."
#   type        = string
# }

# variable "azure_subscription_name" {
#   description = "The name of the Azure subscription."
#   type        = string
# }

# variable "azure_client_id" {
#   description = "The client ID for the Azure service principal."
#   type        = string
# }

# variable "azure_client_secret" {
#   description = "The client secret for the Azure service principal."
#   type        = string
#   sensitive   = true
# }

# variable "azure_tenant_id" {
#   description = "The tenant ID for the Azure service principal."
#   type        = string
# }

# variable "aws_access_key_id" {
#   description = "The access key ID for the AWS service connection."
#   type        = string
#   sensitive   = true
# }

# variable "aws_secret_access_key" {
#   description = "The secret access key for the AWS service connection."
#   type        = string
#   sensitive   = true
# }

# variable "aws_service_connection_name" {
#   description = "The name of the AWS service connection."
#   type        = string
# }

# variable "aws_region" {
#   description = "The region for the AWS service connection."
#   type        = string
# }

# # variable "AGENT_VM_NAME" { type = string }

# # variable "ADMIN_USERNAME" { type = string }
# # variable "ADMIN_PASSWORD" { type = string }
# # variable "VM_SIZE" { type = string }
# # variable "user_data_script_path" {
# #   description = "The path to the user data script"
# #   type        = string
# # }

# variable "resource_suffix" {
#   description = "A suffix to append to resource names"
#   type        = string
# }

# variable "azurerm_vnet_name" {
#   description = "The name of the Azure virtual network"
#   type        = string
# }

# variable "azurerm_subnet_name" {
#   description = "The name of the Azure subnet"
#   type        = string
# }

# variable "azurerm_public_ip_name" {
#   description = "The name of the Azure public IP"
#   type        = string
# }

# variable "azurerm_network_interface_name" {
#   description = "The name of the Azure network interface"
#   type        = string
# }

# variable "azurerm_network_security_group_name" {
#   description = "The name of the Azure network security group"
#   type        = string
# }

# variable "azurerm_linux_vm_name" {
#   description = "The name of the Azure Linux virtual machine"
#   type        = string
# }

# variable "azurerm_vm_admin_username" {
#   description = "The admin username for the Azure VM"
#   type        = string
# }

# variable "azurerm_vm_size" {
#   description = "The size of the Azure VM"
#   type        = string
# }

# variable "azurerm_computer_name" {
#   description = "The computer name for the Azure VM"
#   type        = string
# }


# variable "user_data_script_path" {
#   description = "The path to the user data script"
#   type        = string
# }

// Virtual Machine Variables
variable "name_rg01_public-eastus" {
  description = "The name of the subnet for the virtual network"
  type        = string

}

variable "name_rg01_public-westus" {
  description = "The name of the subnet for the virtual network"
  type        = string

}

variable "name_rg01_public_ip1-eastus" {
  description = "The name of the subnet for the virtual network"
  type        = string

}

variable "name_rg01_public_ip2-eastus" {
  description = "The name of the subnet for the virtual network"
  type        = string

}

variable "name_rg01_public_ip-westus" {
  description = "The name of the subnet for the virtual network"
  type        = string

}

variable "name_rg01_nic1-eastus" {
  description = "The name of the subnet for the virtual network"
  type        = string

}

variable "name_rg01_nic2-eastus" {
  description = "The name of the subnet for the virtual network"
  type        = string

}

variable "name_rg01_nic-westus" {
  description = "The name of the subnet for the virtual network"
  type        = string

}

variable "name_rg01_vm1-eastus" {
  description = "The name of the subnet for the virtual network"
  type        = string

}

variable "name_rg01_vm2-eastus" {
  description = "The name of the subnet for the virtual network"
  type        = string

}

variable "sku" {
  description = "The SKU of the virtual machine"
  type        = string

}
variable "name_rg01_vm-westus" {
  description = "The SKU of the virtual machine"
  type        = string

}

variable "name_az700-rg01-sg-eastus" {
  description = "The name of the network security group"
  type        = string

}

variable "name_az700-rg01-eastus-vnet-01" {
  description = "The name of the virtual network"
  type        = string

}

variable "name_az700-rg01-sg-westus" {
  description = "The name of the network security group"
  type        = string

}

variable "name_az700-rg01-westus-vnet-01" {
  description = "The name of the virtual network"
  type        = string

}

# Application Gateway variables
variable "app_gateway_name" {
  description = "The name of the Application Gateway"
  type        = string
  default     = "app-gateway"
}

variable "app_gateway_public_ip_name" {
  description = "The name of the public IP for the Application Gateway"
  type        = string
  default     = "app-gateway-public-ip"
}

variable "app_gateway_sku_name" {
  description = "The name of the SKU for the Application Gateway"
  type        = string
  default     = "Standard_v2"
}

variable "app_gateway_sku_tier" {
  description = "The tier of the SKU for the Application Gateway"
  type        = string
  default     = "Standard_v2"
}

variable "app_gateway_capacity" {
  description = "The capacity of the Application Gateway"
  type        = number
  default     = 2
}

variable "app_gateway_frontend_port" {
  description = "The frontend port of the Application Gateway"
  type        = number
  default     = 80
}

variable "app_gateway_backend_port" {
  description = "The backend port of the Application Gateway"
  type        = number
  default     = 80
}

variable "app_gateway_request_timeout" {
  description = "The request timeout of the Application Gateway in seconds"
  type        = number
  default     = 20
}