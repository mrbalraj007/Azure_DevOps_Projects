resource "azuredevops_variable_group" "vnet_variables" {
  project_id   = azuredevops_project.project.id
  name         = "vnet-variables"
  description  = "Variable group for VNet variables"
  allow_access = true

  variable {
    name  = "TF_VAR_ACR_ADDRESS_SPACE"
    value = "12.0.0.0/16"
  }

  variable {
    name  = "TF_VAR_ACR_SUBNET_ADDRESS_PREFIX"
    value = "12.0.0.0/16"
  }

  variable {
    name  = "TF_VAR_ACR_SUBNET_NAME"
    value = "acr-subnet"
  }

  variable {
    name  = "TF_VAR_ACR_VNET_NAME"
    value = "acr-vnet"
  }

  variable {
    name  = "TF_VAR_AGENT_ADDRESS_SPACE"
    value = "13.0.0.0/16"
  }

  variable {
    name  = "TF_VAR_AGENT_SUBNET_ADDRESS_PREFIX"
    value = "13.0.0.0/16"
  }

  variable {
    name  = "TF_VAR_AGENT_SUBNET_NAME"
    value = "agent-subnet"
  }

  variable {
    name  = "TF_VAR_AGENT_VNET_NAME"
    value = "agent-vnet"
  }

  variable {
    name  = "TF_VAR_AKS_ADDRESS_SPACE"
    value = "11.0.0.0/12"
  }

  variable {
    name  = "TF_VAR_AKS_SUBNET_ADDRESS_PREFIX"
    value = "11.0.0.0/16"
  }

  variable {
    name  = "TF_VAR_AKS_SUBNET_NAME"
    value = "aks-subnet"
  }

  variable {
    name  = "TF_VAR_AKS_VNET_NAME"
    value = "aks-vnet"
  }

  variable {
    name  = "TF_VAR_APPGW_SUBNET_ADDRESS_PREFIX"
    value = "11.1.0.0/24"
  }

  variable {
    name  = "TF_VAR_APPGW_SUBNET_NAME"
    value = "appgw-subnet"
  }
}

resource "azuredevops_variable_group" "acr_variables" {
  project_id   = azuredevops_project.project.id
  name         = "acr_variables"
  description  = "Variable group for ACR variables"
  allow_access = true

   variable {
    name  = "need to update"
    value = "need to update"
  }
}

resource "azuredevops_variable_group" "aks_variables" {
  project_id   = azuredevops_project.project.id
  name         = "aks_variables"
  description  = "Variable group for AKS variables"
  allow_access = true

   variable {
    name  = "need to update"
    value = "need to update"
  }
  // Add variables as needed
}

resource "azuredevops_variable_group" "appgw_variables" {
  project_id   = azuredevops_project.project.id
  name         = "appgw_variables"
  description  = "Variable group for Application Gateway variables"
  allow_access = true

   variable {
    name  = "need to update"
    value = "need to update"
  }
  // Add variables as needed
}

resource "azuredevops_variable_group" "db_variables" {
  project_id   = azuredevops_project.project.id
  name         = "db_variables"
  description  = "Variable group for Database variables"
  allow_access = true

   variable {
    name  = "need to update"
    value = "need to update"
  }
  // Add variables as needed
}

resource "azuredevops_variable_group" "global_variables" {
  project_id   = azuredevops_project.project.id
  name         = "global-variables"
  description  = "Variable group for Global variables"
  allow_access = true

   variable {
    name  = "need to update"
    value = "need to update"
  }
  // Add variables as needed
}

resource "azuredevops_variable_group" "secrets" {
  project_id   = azuredevops_project.project.id
  name         = "secrets"
  description  = "Variable group for Secrets"
  allow_access = true

   variable {
    name  = "need to update"
    value = "need to update"
  }
  // Add variables as needed
}

resource "azuredevops_variable_group" "vm_variables" {
  project_id   = azuredevops_project.project.id
  name         = "vm_variables"
  description  = "Variable group for VM variables"
  allow_access = true

   variable {
    name  = "need to update"
    value = "need to update"
  }
  // Add variables as needed
}
