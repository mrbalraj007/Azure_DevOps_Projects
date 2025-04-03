provider "azurerm" {
  features {}
}

provider "azuread" {
}

data "azurerm_client_config" "current" {}

# Create the app registration first
resource "azuread_application" "enterprise_app" {
  display_name = "AWS_SSO_Enterprise_App"

  web {
    homepage_url  = "https://signin.aws.amazon.com/saml"
    redirect_uris = ["https://signin.aws.amazon.com/saml"]
  }

  # Add app roles for AWS access
  app_role {
    allowed_member_types = ["User"]
    description          = "AWS Administrator Access"
    display_name         = "AWS Administrator"
    enabled              = true
    id                   = uuid() # Using dynamic UUID instead of hardcoded ID
    value                = "Admin"
  }

  app_role {
    allowed_member_types = ["User"]
    description          = "AWS Read-Only Access"
    display_name         = "AWS ReadOnly"
    enabled              = true
    id                   = uuid() # Using dynamic UUID instead of hardcoded ID
    value                = "ReadOnly"
  }

  # Required for SAML
  group_membership_claims = ["ApplicationGroup", "SecurityGroup"]

  # Remove the identifier_uris that's causing the problem
  # Azure will auto-assign an application ID URI 

  feature_tags {
    enterprise = true
    gallery    = false
  }
}

# Create the service principal (Enterprise Application)
resource "azuread_service_principal" "enterprise_app_sp" {
  client_id                    = azuread_application.enterprise_app.client_id
  app_role_assignment_required = true

  feature_tags {
    enterprise = true
    gallery    = false
  }
}

# Add SAML SSO specific attributes for AWS
resource "azuread_application_optional_claims" "saml_claims" {
  application_id = azuread_application.enterprise_app.id

  saml2_token {
    name                  = "groups"
    essential             = true
    additional_properties = []
  }

  saml2_token {
    name                  = "upn"
    essential             = true
    additional_properties = []
  }
}

# Create federated credential
resource "azuread_application_federated_identity_credential" "aws_sso" {
  application_id = azuread_application.enterprise_app.id
  display_name   = "AWS-SSO-Federation"
  description    = "Federated identity for AWS SSO integration"
  audiences      = ["https://signin.aws.amazon.com/saml"]
  issuer         = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/v2.0"
  subject        = "aws-federation"
}

# Output the Enterprise Application URL for access
output "enterprise_application_url" {
  value = "https://portal.azure.com/#blade/Microsoft_AAD_IAM/ManagedAppMenuBlade/Overview/appId/${azuread_application.enterprise_app.client_id}/objectId/${azuread_service_principal.enterprise_app_sp.id}"
}

output "azure_ad_tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "enterprise_app_id" {
  value = azuread_application.enterprise_app.client_id
}

output "metadata_endpoint" {
  value = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/federationmetadata/2007-06/federationmetadata.xml"
}
