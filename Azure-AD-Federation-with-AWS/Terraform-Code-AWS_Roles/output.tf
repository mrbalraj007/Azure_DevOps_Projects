# SAML Provider outputs
output "saml_provider_arn" {
  description = "ARN of the SAML provider"
  value       = aws_iam_saml_provider.saml_provider.arn
}

output "saml_provider_name" {
  description = "Name of the SAML provider"
  value       = aws_iam_saml_provider.saml_provider.name
}

output "saml_provider_valid_until" {
  description = "Expiration timestamp of the SAML provider"
  value       = aws_iam_saml_provider.saml_provider.valid_until
}

# IAM Role outputs
output "admin_role_arn" {
  description = "ARN of the admin role"
  value       = aws_iam_role.aws_admin.arn
}

output "admin_role_name" {
  description = "Name of the admin role"
  value       = aws_iam_role.aws_admin.name
}

output "admin_role_id" {
  description = "ID of the admin role"
  value       = aws_iam_role.aws_admin.id
}

output "readonly_role_arn" {
  description = "ARN of the read-only role"
  value       = aws_iam_role.aws_ro.arn
}

output "readonly_role_name" {
  description = "Name of the read-only role"
  value       = aws_iam_role.aws_ro.name
}

output "readonly_role_id" {
  description = "ID of the read-only role"
  value       = aws_iam_role.aws_ro.id
}

# IAM User outputs
output "iam_user_arn" {
  description = "ARN of the IAM user"
  value       = aws_iam_user.new_user.arn
}

output "iam_user_name" {
  description = "Name of the IAM user"
  value       = aws_iam_user.new_user.name
}

output "iam_user_unique_id" {
  description = "Unique ID of the IAM user"
  value       = aws_iam_user.new_user.unique_id
}

# IAM Policy outputs
output "custom_policy_arn" {
  description = "ARN of the custom permission policy"
  value       = aws_iam_policy.custom_permission_policy.arn
}

output "custom_policy_id" {
  description = "ID of the custom permission policy"
  value       = aws_iam_policy.custom_permission_policy.id
}

output "custom_policy_name" {
  description = "Name of the custom permission policy"
  value       = aws_iam_policy.custom_permission_policy.name
}

# Summary Information
output "configuration_summary" {
  description = "Summary of the AWS-Azure AD federation configuration"
  value = {
    saml_provider = var.saml_provider_name
    admin_role    = var.admin_role_name
    readonly_role = var.readonly_role_name
    iam_user      = var.iam_user_name
    admin_email   = var.admin_email
    readonly_email = var.readonly_email
  }
}
