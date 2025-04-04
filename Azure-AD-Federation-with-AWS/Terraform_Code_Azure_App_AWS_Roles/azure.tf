provider "azurerm" {
  features {}
}

provider "azuread" {
}

# Unified data sources - removed duplicates
data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}

# Create the app registration first
resource "azuread_application" "enterprise_app" {
  display_name = "AWS_SSO_Enterprise_App"

  # Remove identifier_uris as it must use a verified domain
  # identifier_uris = ["https://signin.aws.amazon.com/saml"]

  web {
    homepage_url  = "https://signin.aws.amazon.com/saml"
    redirect_uris = ["https://signin.aws.amazon.com/saml"]

    # Configure implicit authentication settings for SAML
    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
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
    enterprise            = true
    gallery               = false
    custom_single_sign_on = true # Enable custom SSO
  }

  # Specify publisher as Amazon
  owners = [data.azurerm_client_config.current.object_id]
}

# Note: AWS does not support automatic SCIM provisioning.
# User access will be managed through Azure AD group and user assignments to this application.

# Create the service principal (Enterprise Application)
resource "azuread_service_principal" "enterprise_app_sp" {
  client_id                    = azuread_application.enterprise_app.client_id
  app_role_assignment_required = true

  preferred_single_sign_on_mode = "saml"
  notification_email_addresses  = []

  feature_tags {
    enterprise            = true
    gallery               = false
    custom_single_sign_on = true
  }

  # Removed conflicting and unconfigurable attributes:
  # - tags (conflicts with feature_tags)
  # - homepage_url (not configurable)
  # - login_url (not configurable)
}

# Generate a token signing certificate for SAML
resource "azuread_service_principal_token_signing_certificate" "saml_cert" {
  service_principal_id = azuread_service_principal.enterprise_app_sp.id
  display_name         = "CN=AWS-SSO-SAML-Certificate" # Fixed format with CN= prefix
  end_date             = timeadd(timestamp(), "8760h") # 1 year validity
}

# Configure SSO settings for the service principal
resource "azuread_app_role_assignment" "saml_admin_role" {
  principal_object_id = azuread_service_principal.enterprise_app_sp.object_id
  resource_object_id  = azuread_service_principal.enterprise_app_sp.object_id
  app_role_id         = [for role in azuread_application.enterprise_app.app_role : role.id if role.value == "Admin"][0]
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

# Remove the unsupported resource
# resource "azuread_service_principal_saml_single_sign_on" "aws_sso" {
#   service_principal_id  = azuread_service_principal.enterprise_app_sp.id
#   relay_state           = "https://console.aws.amazon.com/"
#   entity_id             = "https://signin.aws.amazon.com/saml"
# }

# Assign current user to the app (for demonstration)
# Using the correct data source for user ID
resource "azuread_app_role_assignment" "current_user_assignment" {
  app_role_id         = [for role in azuread_application.enterprise_app.app_role : role.id if role.value == "Admin"][0]
  principal_object_id = data.azuread_client_config.current.object_id
  resource_object_id  = azuread_service_principal.enterprise_app_sp.object_id
}

# Use null_resource with local-exec to remind about SAML attribute mapping
resource "null_resource" "saml_attributes_configuration" {
  depends_on = [
    azuread_application.enterprise_app,
    azuread_service_principal.enterprise_app_sp
  ]

  provisioner "local-exec" {
    command = <<EOT
    echo "===========================================================================" 
    echo "CRITICAL: You MUST manually configure these SAML settings in the Azure Portal"
    echo "Go to: https://portal.azure.com/#blade/Microsoft_AAD_IAM/ManagedAppMenuBlade/SingleSignOn/appId/${azuread_application.enterprise_app.client_id}/objectId/${azuread_service_principal.enterprise_app_sp.id}"
    echo ""
    echo "** REQUIRED: Set 'Identifier (Entity ID)' to 'https://signin.aws.amazon.com/saml' **"
    echo "  This identifier cannot be set programmatically without a verified domain"
    echo ""
    echo "Under 'User Attributes & Claims', add the following attribute mappings:"
    echo "1. RoleSessionName - user.userprincipalname - https://aws.amazon.com/SAML/Attributes"
    echo "2. Role - user.assignedroles - https://aws.amazon.com/SAML/Attributes"
    echo "3. SessionDuration - user.sessionduration - https://aws.amazon.com/SAML/Attributes" 
    echo "==========================================================================="
    EOT
  }
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

output "saml_download_url" {
  value       = "https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/SingleSignOn/appId/${azuread_application.enterprise_app.client_id}/objectId/${azuread_application.enterprise_app.object_id}"
  description = "URL to download SAML Federation Metadata XML file from Azure portal"
}

# Output the newly generated certificate information
output "saml_certificate_expiry" {
  value = azuread_service_principal_token_signing_certificate.saml_cert.end_date
}

output "saml_certificate_thumbprint" {
  value = azuread_service_principal_token_signing_certificate.saml_cert.thumbprint
}

# Additional output about provisioning limitations
output "provisioning_note" {
  value = "NOTE: Automatic SCIM provisioning is not supported for AWS SSO. User provisioning should be done through Azure AD group/user assignments to roles in this enterprise application."
}

output "provisioning_instructions" {
  value = "To provision users:\n1. Go to Enterprise App > Users and Groups\n2. Add users/groups\n3. Assign to appropriate app roles (Admin/ReadOnly)\n4. These roles will map to corresponding AWS roles during federation"
}

# Output instructions for assigning users
output "user_assignment_instructions" {
  value = "To make this app visible to users in MyApplications, assign users to the app through Azure Portal or using the Azure CLI command: az ad app permission grant --id ${azuread_application.enterprise_app.client_id} --user <user_object_id>"
}

# Add output to remind about manual configuration
output "saml_configuration_note" {
  value = <<EOT
CRITICAL: After deployment, complete these manual SAML configuration steps:

1. Go to Azure Portal > Enterprise Applications > AWS_SSO_Enterprise_App > Single sign-on
2. ** REQUIRED: Set 'Identifier (Entity ID)' to 'https://signin.aws.amazon.com/saml' **
   This field appears in red and must be set manually due to domain verification requirements.
3. Reply URL should already be set to 'https://signin.aws.amazon.com/saml'
4. Under 'User Attributes & Claims', add these attribute mappings:
   - Name: RoleSessionName, Source: user.userprincipalname, Namespace: https://aws.amazon.com/SAML/Attributes
   - Name: Role, Source: user.assignedroles, Namespace: https://aws.amazon.com/SAML/Attributes
   - Name: SessionDuration, Source: user.sessionduration, Namespace: https://aws.amazon.com/SAML/Attributes

The application will not work without these manual configurations.
EOT
}

# Add post-deployment verification instructions
output "verification_steps" {
  value = <<EOT
After manual configuration, verify your setup:

1. Confirm Entity ID is set to 'https://signin.aws.amazon.com/saml'
2. Test sign-in with a user assigned to the application
3. Verify the user can access AWS resources according to their role
EOT
}
