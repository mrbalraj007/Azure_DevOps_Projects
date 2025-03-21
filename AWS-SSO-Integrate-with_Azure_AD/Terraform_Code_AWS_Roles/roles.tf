resource "aws_iam_role" "roles" {
  count = length(var.role_names)
  name  = var.role_names[count.index]
  assume_role_policy = jsonencode({
    Version = var.assume_role_policy_version
    Statement = [
      {
        Action = var.assume_role_policy_action
        Effect = var.assume_role_policy_effect
        Sid    = ""
        Principal = {
          Service = var.assume_role_policy_service
        }
      },
    ]
  })
  description = "IAM role for ${var.role_names[count.index]}, and managed by terraform"
}

resource "aws_iam_role_policy_attachment" "admin_policy_attachment" {
  count      = length(var.role_names)
  role       = aws_iam_role.roles[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
