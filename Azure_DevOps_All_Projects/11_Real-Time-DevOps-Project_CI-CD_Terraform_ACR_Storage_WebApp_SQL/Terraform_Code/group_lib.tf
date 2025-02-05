resource "azuredevops_variable_group" "vnet-variables" {
  project_id   = azuredevops_project.project.id
  name         = "vnet-variables"
  description  = "Variable group for vnet-variables variables"
  allow_access = true

  variable {
    name = "TF_VAR_ACR_ADDRESS_SPACE"
    #value = "Update here"
    value = var.ACR_ADDRESS_SPACE
  }
  variable {
    name = "TF_VAR_ACR_SUBNET_ADDRESS_PREFIX"
    #value = "Update here"
    value = var.ACR_SUBNET_ADDRESS_PREFIX
  }


  variable {
    name = "TF_VAR_ACR_SUBNET_NAME"
    #value = "Update here"
    value = var.ACR_SUBNET_NAME
  }

  variable {
    name = "TF_VAR_ACR_VNET_NAME"
    #value = "Update here"
    value = var.ACR_VNET_NAME
  }

  variable {
    name = "TF_VAR_AGENT_ADDRESS_SPACE"
    #value = "Update here"
    value = var.AGENT_ADDRESS_SPACE
  }

  variable {
    name = "TF_VAR_AGENT_SUBNET_ADDRESS_PREFIX"
    #value = "Update here"
    value = var.AGENT_SUBNET_ADDRESS_PREFIX
  }

  variable {
    name = "TF_VAR_AGENT_SUBNET_NAME"
    #value = "Update here"
    value = var.AGENT_SUBNET_NAME
  }

  variable {
    name = "TF_VAR_AGENT_VNET_NAME"
    #value = "Update here"
    value = var.AGENT_VNET_NAME
  }

  variable {
    name = "TF_VAR_AKS_ADDRESS_SPACE"
    #value = "Update here"
    value = var.AKS_ADDRESS_SPACE
  }

  variable {
    name = "TF_VAR_AKS_SUBNET_ADDRESS_PREFIX"
    #value = "Update here"
    value = var.AKS_SUBNET_ADDRESS_PREFIX
  }

  variable {
    name = "TF_VAR_AKS_SUBNET_NAME"
    #value = "Update here"
    value = var.AKS_SUBNET_NAME
  }

  variable {
    name = "TF_VAR_AKS_VNET_NAME"
    #value = "Update here"
    value = var.AKS_VNET_NAME
  }

  variable {
    name = "TF_VAR_APPGW_SUBNET_ADDRESS_PREFIX"
    #value = "Update here"
    value = var.APPGW_SUBNET_ADDRESS_PREFIX
  }

  variable {
    name = "TF_VAR_APPGW_SUBNET_NAME"
    #value = "Update here"
    value = var.APPGW_SUBNET_NAME
  }
}

resource "azuredevops_variable_group" "vmvariables" {
  project_id   = azuredevops_project.project.id
  name         = "vm_variables"
  description  = "Variable group for VM"
  allow_access = true

  variable {
    name  = "TF_VAR_ADMIN_PASSWORD"
    value = var.ADMIN_PASSWORD
  }

  variable {
    name  = "TF_VAR_ADMIN_USERNAME"
    value = var.ADMIN_USERNAME
  }


  variable {
    name  = "TF_VAR_AGENT_VM_NAME"
    value = var.AGENT_VM_NAME
  }

  variable {
    name  = "TF_VAR_VM_SIZE"
    value = var.VM_SIZE
  }
}


resource "azuredevops_variable_group" "appgwvariables" {
  project_id   = azuredevops_project.project.id
  name         = "appgw_variables"
  description  = "Variable group for application Gateway"
  allow_access = true

  variable {
    name  = "TF_VAR_APP_GATEWAY_NAME"
    value = var.APP_GATEWAY_NAME
  }

  variable {
    name  = "TF_VAR_APPGW_PUBLIC_IP_NAME"
    value = var.APPGW_PUBLIC_IP_NAME
  }


  variable {
    name  = "TF_VAR_VIRTUAL_NETWORK_NAME"
    value = var.VIRTUAL_NETWORK_NAME
  }
}

resource "azuredevops_variable_group" "acrvariables" {
  project_id   = azuredevops_project.project.id
  name         = "acr_variables"
  description  = "Variable group for Azure Container Registry"
  allow_access = true

  variable {
    name  = "TF_VAR_ACR_SKU"
    value = var.ACR_SKU
  }
  variable {
    name  = "TF_VAR_PRIVATE_ACR_NAME"
    value = var.PRIVATE_ACR_NAME
  }
}

resource "azuredevops_variable_group" "aksvariables" {
  project_id   = azuredevops_project.project.id
  name         = "aks_variables"
  description  = "Variable group for Azure Container Registry"
  allow_access = true

  variable {
    name  = "TF_VAR_DNS_PREFIX"
    value = var.AKS_DNS_PREFIX
  }
  variable {
    name  = "TF_VAR_NAME"
    value = var.AKS_NAME
  }
  variable {
    name  = "TF_VAR_SSH_PUBLIC_KEY"
    value = var.AKS_SSH_PUBLIC_KEY
  }


  variable {
    name  = "TF_VAR_APP_GATEWAY_NAME"
    value = var.APP_GATEWAY_NAME
  }

  variable {
    name  = "TF_VAR_AKS_VNET_NAME"
    value = var.AKS_VNET_NAME
  }


  variable {
    name  = "TF_VAR_ACR_SUBNET_NAME"
    value = var.ACR_SUBNET_NAME
  }

  variable {
    name  = "TF_VAR_ACR_VNET_NAME"
    value = var.ACR_VNET_NAME
  }

  variable {
    name  = "TF_VAR_AGENT_VNET_NAME"
    value = var.AGENT_VNET_NAME
  }

  variable {
    name  = "TF_VAR_PRIVATE_ACR_NAME"
    value = var.PRIVATE_ACR_NAME
  }

  variable {
    name  = "TF_VAR_APPGW_SUBNET_NAME"
    value = var.APPGW_SUBNET_NAME
  }


  variable {
    name  = "TF_VAR_VIRTUAL_NETWORK_NAME"
    value = var.VIRTUAL_NETWORK_NAME
  }

}

resource "azuredevops_variable_group" "dbvariables" {
  project_id   = azuredevops_project.project.id
  name         = "db_variables"
  description  = "Variable group for Database"
  allow_access = true

  variable {
    name  = "TF_VAR_COLLATION"
    value = var.DB_COLLATION
  }
  variable {
    name  = "TF_VAR_DB_NAME"
    value = var.DB_NAME
  }
  variable {
    name  = "TF_VAR_DBPASSWORD"
    value = var.DBPASSWORD
  }

  variable {
    name  = "TF_VAR_DBSERVER_NAME"
    value = var.DBSERVER_NAME
  }
  variable {
    name  = "TF_VAR_DBUSERNAME"
    value = var.DBUSERNAME
  }

  variable {
    name  = "TF_VAR_VNETRULE"
    value = var.VNETRULE
  }
}
resource "azuredevops_variable_group" "globalvariables" {
  project_id   = azuredevops_project.project.id
  name         = "global-variables"
  description  = "Variable group for global"
  allow_access = true

  variable {
    name  = "TF_VAR_LOCATION"
    value = var.location
  }
  variable {
    name  = "TF_VAR_RESOURCE_GROUP_NAME"
    value = var.resource_group_name
  }
}


resource "azuredevops_variable_group" "secretvariables" {
  project_id   = azuredevops_project.project.id
  name         = "secrets"
  description  = "Variable group for secrets"
  allow_access = true

  variable {
    name  = "TF_VAR_SUBSCRIPTION_ID"
    value = var.SUBSCRIPTION_ID
  }
}
