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
    null_resource.dependency_order
  ]

  name                   = "AzureAD_SAML_Provider"
  saml_metadata_document = data.http.saml_metadata.response_body
}

resource "aws_iam_role" "sso_role" {
  name = "AzureAD_SSO_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_saml_provider.azure_saml.arn
        }
        Action = "sts:AssumeRoleWithSAML"
        Condition = {
          StringEquals = {
            "SAML:aud" = "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "sso_policy" {
  role = aws_iam_role.sso_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:Describe*"]
        Resource = "*"
      }
    ]
  })
}
