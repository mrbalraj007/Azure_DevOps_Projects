resource "azuredevops_variable_group" "rg-variables" {
  project_id   = azuredevops_project.project.id
  name         = "rg-variables"
  description  = "Variable group for rg-variables"
  allow_access = true

  variable {
    name  = "TF_VAR_resource_group_name"
    value = var.resource_group_name
  }
  variable {
    name = "TF_VAR_location"
    #value = "Update here"
    value = var.location
  }

}