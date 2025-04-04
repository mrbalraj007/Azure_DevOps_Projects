provider "azurerm" {
  features {}
}

provider "azuread" {
}

data "azurerm_client_config" "current" {}

# Create the app registration first
resource "azuread_application" "enterprise_app" {
  display_name = "AWS_SINGH_SSO"

  # Add identifier URI for SAML
  identifier_uris = ["https://signin.aws.amazon.com/saml"]

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

  feature_tags {
    enterprise = true
    gallery    = false
    custom_single_sign_on = true
  }
}

# Create the service principal (Enterprise Application)
resource "azuread_service_principal" "enterprise_app_sp" {
  client_id                    = azuread_application.enterprise_app.client_id
  app_role_assignment_required = true

  feature_tags {
    enterprise = true
    gallery    = false
    custom_single_sign_on = true
  }

  preferred_single_sign_on_mode = "saml"
  notification_email_addresses  = []
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
  display_name   = "AWS-SINGH-Federation"
  description    = "Federated identity for AWS SSO integration"
  audiences      = ["https://signin.aws.amazon.com/saml"]
  issuer         = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/v2.0"
  subject        = "aws-federation"
}

# Add SAML certificate for the enterprise application
resource "azuread_service_principal_token_signing_certificate" "saml_cert" {
  service_principal_id = azuread_service_principal.enterprise_app_sp.id
  display_name         = "CN=AWS SAML Certificate"
  end_date             = timeadd(timestamp(), "8760h") # Valid for 1 year
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

# Add output for certificate information
output "saml_certificate_info" {
  value = "SAML certificate created with display name: ${azuread_service_principal_token_signing_certificate.saml_cert.display_name}, expiring on: ${azuread_service_principal_token_signing_certificate.saml_cert.end_date}"
}