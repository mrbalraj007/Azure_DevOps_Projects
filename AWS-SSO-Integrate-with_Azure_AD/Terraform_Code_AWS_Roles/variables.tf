variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "role_names" {
  description = "List of role names to create"
  type        = list(string)
}

variable "assume_role_policy_version" {
  description = "Version of the assume role policy"
  type        = string
}

variable "assume_role_policy_action" {
  description = "Action for the assume role policy"
  type        = string
}

variable "assume_role_policy_effect" {
  description = "Effect for the assume role policy"
  type        = string
}

variable "assume_role_policy_service" {
  description = "Service for the assume role policy"
  type        = string
}
