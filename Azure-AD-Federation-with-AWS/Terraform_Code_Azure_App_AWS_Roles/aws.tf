provider "aws" {
  region = "us-east-1"
}

provider "http" {}

# Direct reference to Azure tenant ID from azure.tf
data "http" "saml_metadata" {
  url = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/federationmetadata/2007-06/federationmetadata.xml"

  request_headers = {
    Accept = "application/xml"
  }
}

resource "aws_iam_saml_provider" "azure_saml" {
  # Add dependency to ensure Azure resources are created first
  depends_on = [
    azuread_application.enterprise_app,
    azuread_service_principal.enterprise_app_sp,
    azuread_application_federated_identity_credential.aws_sso,
    azuread_service_principal_token_signing_certificate.saml_cert, # Add dependency on the certificate
    null_resource.dependency_order
  ]

  name                   = "AzureAD_SAML_Provider"
  saml_metadata_document = data.http.saml_metadata.response_body
}

# IAM List Roles Policy
resource "aws_iam_policy" "list_roles_policy" {
  name        = "ListRolesPolicy"
  description = "Policy that allows listing IAM roles"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "VisualEditor0",
        Effect   = "Allow",
        Action   = "iam:ListRoles",
        Resource = "*"
      }
    ]
  })
}

# AADAdmin Role - Administrator Access
resource "aws_iam_role" "aad_admin_role" {
  name = "AADAdmin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_saml_provider.azure_saml.arn
        },
        Action = "sts:AssumeRoleWithSAML",
        Condition = {
          StringEquals = {
            "SAML:aud" = "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })
}

# Attach Administrator Access policy to AADAdmin role
resource "aws_iam_role_policy_attachment" "admin_policy" {
  role       = aws_iam_role.aad_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# AADS3RO Role - ViewOnly + S3ReadOnly Access
resource "aws_iam_role" "aad_s3_ro_role" {
  name = "AADS3RO"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_saml_provider.azure_saml.arn
        },
        Action = "sts:AssumeRoleWithSAML",
        Condition = {
          StringEquals = {
            "SAML:aud" = "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })
}

# Attach ViewOnlyAccess policy to AADS3RO role
resource "aws_iam_role_policy_attachment" "view_only_policy" {
  role       = aws_iam_role.aad_s3_ro_role.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}

# Attach S3ReadOnlyAccess policy to AADS3RO role
resource "aws_iam_role_policy_attachment" "s3_read_only_policy" {
  role       = aws_iam_role.aad_s3_ro_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Create AzureSSOProvisioner user
resource "aws_iam_user" "azure_sso_provisioner" {
  name = "AzureSSOProvisioner"
  path = "/"
}

# Attach ListRolesPolicy to AzureSSOProvisioner user
resource "aws_iam_user_policy_attachment" "azure_sso_provisioner_list_roles" {
  user       = aws_iam_user.azure_sso_provisioner.name
  policy_arn = aws_iam_policy.list_roles_policy.arn
}

# Create access keys for programmatic access (optional)
resource "aws_iam_access_key" "azure_sso_provisioner_key" {
  user = aws_iam_user.azure_sso_provisioner.name
}

# Output the Role ARNs
output "aad_admin_role_arn" {
  value = aws_iam_role.aad_admin_role.arn
}

output "aad_s3_ro_role_arn" {
  value = aws_iam_role.aad_s3_ro_role.arn
}

output "saml_provider_arn" {
  value = aws_iam_saml_provider.azure_saml.arn
}

# Additional output for the new user
output "azure_sso_provisioner_arn" {
  value = aws_iam_user.azure_sso_provisioner.arn
}

output "azure_sso_provisioner_access_key_id" {
  value     = aws_iam_access_key.azure_sso_provisioner_key.id
  sensitive = true
}

output "azure_sso_provisioner_secret_access_key" {
  value     = aws_iam_access_key.azure_sso_provisioner_key.secret
  sensitive = true
}
