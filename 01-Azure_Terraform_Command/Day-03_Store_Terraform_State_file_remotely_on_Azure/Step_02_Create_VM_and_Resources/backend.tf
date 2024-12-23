terraform {
  backend "azurerm" {
    resource_group_name  = "testRG"
    storage_account_name = "storageacctf834da40"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
