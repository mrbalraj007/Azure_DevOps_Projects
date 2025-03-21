output "role_names" {
  value       = aws_iam_role.roles[*].name
  description = "List of IAM role names"
}

output "role_arns" {
  value       = aws_iam_role.roles[*].arn
  description = "List of IAM role ARNs"
}
