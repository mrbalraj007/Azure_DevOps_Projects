terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.0.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">=3.0.0"
    }
  }
  required_version = ">=1.0.0"
}
