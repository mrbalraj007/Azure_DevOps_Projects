# variable "resource_group_name" {
#   description = "The name of the resource group"
#   type        = string
# }

# variable "location" {
#   description = "The location of the resources"
#   type        = string
# }

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

variable "resource_suffix" {
  description = "The suffix to append to resource names."
  type        = string
  default     = "First_Project"
}

