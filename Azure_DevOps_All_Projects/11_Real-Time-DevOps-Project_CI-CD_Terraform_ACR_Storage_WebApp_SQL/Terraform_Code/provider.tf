provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.54.0, <4.0.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }

  # backend "azurerm" {
  #   resource_group_name   = var.resource_group_name
  #   storage_account_name  = azurerm_storage_account.str-acct.name
  #   container_name        = azurerm_storage_container.str-container.name
  #   key                   = "terraform.tfstate"
  # }
}

provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/${var.azure_devops_organization}"
  personal_access_token = var.azure_devops_pat
}