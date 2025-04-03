# This file is added to demonstrate the order of deployment
# and dependencies between Azure and AWS resources

terraform {
  required_version = ">=1.0.0"
}

# Define an explicit dependency between AWS and Azure resources
# to ensure Azure resources are created before AWS resources
resource "null_resource" "dependency_order" {
  depends_on = [
    azuread_application.enterprise_app,
    azuread_service_principal.enterprise_app_sp,
    azuread_application_federated_identity_credential.aws_sso
  ]
}

# Remove the duplicate aws_iam_saml_provider resource
# Instead, we'll update the one in aws.tf

output "integration_status" {
  value = "Azure AD and AWS SSO integration complete"
  depends_on = [
    azuread_application.enterprise_app,
    aws_iam_saml_provider.azure_saml,
    aws_iam_role.aad_admin_role,
    aws_iam_role.aad_s3_ro_role
  ]
}
