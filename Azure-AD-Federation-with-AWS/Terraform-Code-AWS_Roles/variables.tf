variable "saml_provider_name" {
  description = "Name of the SAML provider"
  type        = string
  default     = "AzureAD-SAML-Provider"
}

variable "saml_metadata_file_path" {
  description = "Path to the SAML metadata file"
  type        = string
  default     = "saml_metadata.xml"
}

variable "admin_role_name" {
  description = "Name of the admin role"
  type        = string
  default     = "AWS-Admin"
}

variable "readonly_role_name" {
  description = "Name of the read-only role"
  type        = string
  default     = "AWS-RO"
}

variable "admin_email" {
  description = "Email address for the admin user"
  type        = string
  default     = "admin@example.com"
}

variable "readonly_email" {
  description = "Email address for the read-only user"
  type        = string
  default     = "readonly@example.com"
}

variable "iam_user_name" {
  description = "Name of the IAM user"
  type        = string
  default     = "AzureSSOUser"
}

variable "custom_policy_name" {
  description = "Name of the custom policy"
  type        = string
  default     = "CustomPermissionPolicy"
}

variable "custom_policy_description" {
  description = "Description of the custom policy"
  type        = string
  default     = "Custom policy for AzureSSOUser"
}

variable "custom_policy_actions" {
  description = "List of actions allowed by the custom policy"
  type        = list(string)
  default     = ["s3:ListBucket", "s3:GetObject", "ec2:DescribeInstances"]
}
