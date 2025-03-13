resource "azurerm_resource_group" "rg01" {
  name     = var.resource_group_name_01
  location = var.location_01
}

# resource "azurerm_resource_group" "rg02" {
#   #name     = "az700-rg02"
#   name     = var.resource_group_name_02
#   location = var.location_02
# }

# resource "azurerm_resource_group" "rg03" {
#   #name     = "az700-rg03"
#   name     = var.resource_group_name_03
#   location = var.location_03
# }