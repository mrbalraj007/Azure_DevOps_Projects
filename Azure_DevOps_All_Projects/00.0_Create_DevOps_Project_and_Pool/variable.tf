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
