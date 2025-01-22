resource "azuredevops_variable_group" "comman_parameters" {
  project_id   = azuredevops_project.project.id
  name         = "Comman_parameters"
  description  = "Variable group for Comman_parameters variables"
  allow_access = true

  variable {
    name  = "TF_VAR_CLIENT_ID"
    value = "Update here"
  }

  variable {
    name  = "TF_VAR_CLIENT_SECRET"
    value = "Update here"
  }
  variable {
    name  = "TF_VAR_SUBSCRIPTION_ID"
    value = "Update here"
  }

  variable {
    name  = "TF_VAR_TENANT_ID"
    value = "Update here"
  }
  variable {
    name  = "TF_VAR_CUSTOM_EMAILS"
    value = "Update here"
  }

  variable {
    name  = "TF_VAR_DOCKER_REGISTRY_SERVER_PASSWORD"
    value = "xxx"
  }

  variable {
    name  = "TF_VAR_DOCKER_REGISTRY_SERVER_URL"
    value = "xxx"
  }

  variable {
    name  = "TF_VAR_DOCKER_REGISTRY_SERVER_USERNAME"
    value = "xxxx"
  }

  variable {
    name = "TF_VAR_LOCATION"
    #value = "West US 2"
    value = var.location
  }

  variable {
    name  = "TF_VAR_OS_TYPE"
    value = "Linux"
  }

  variable {
    name = "TF_VAR_RG_Name"
    #value = "rg-20012025"
    value = var.resource_group_name
  }


}

resource "azuredevops_variable_group" "dev-var" {
  project_id   = azuredevops_project.project.id
  name         = "Dev-var"
  description  = "Variable group for Dev variables"
  allow_access = true

  variable {
    name  = "TF_VAR_APP_AUTOSCALE"
    value = "Dev-Autoscale"
  }

  variable {
    name  = "TF_VAR_OS_TYPE"
    value = "Linux"
  }


  variable {
    name = "TF_VAR_SKU_NAME"
    # value = "P1v2"
    value = "B1"
  }

  variable {
    name  = "TF_VAR_WEBAPP_NAME_PREFIX"
    value = "demo-app"
  }

  variable {
    name  = "TF_VAR_WEBAPP_PLAN_NAME"
    value = "dev-demo-app"
  }

  variable {
    name  = "TF_VAR_WEBAPPNAME"
    value = "dev-demo-application-25052025"
  }
}



resource "azuredevops_variable_group" "qa-var" {
  project_id   = azuredevops_project.project.id
  name         = "QA-var"
  description  = "Variable group for QA variables"
  allow_access = true

  variable {
    name  = "TF_VAR_APP_AUTOSCALE"
    value = "QA-Autoscale"
  }

  variable {
    name  = "TF_VAR_OS_TYPE"
    value = "Linux"
  }


  variable {
    name = "TF_VAR_SKU_NAME"
    # value = "P1v2"
    value = "B1"
  }

  variable {
    name  = "TF_VAR_WEBAPP_NAME_PREFIX"
    value = "demo-app"
  }

  variable {
    name  = "TF_VAR_WEBAPP_PLAN_NAME"
    value = "QA-demo-app"
  }

  variable {
    name  = "TF_VAR_WEBAPPNAME"
    value = "QA-demo-application-25052025"
  }
}
