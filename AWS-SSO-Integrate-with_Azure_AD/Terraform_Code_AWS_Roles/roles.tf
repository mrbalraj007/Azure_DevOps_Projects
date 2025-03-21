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

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count      = length([for i, role in var.role_names : role if role == "AWS_M_Admin" || var.role_policies[i] != ""])
  role       = aws_iam_role.roles[count.index].name
  policy_arn = var.role_names[count.index] == "AWS_M_Admin" ? "arn:aws:iam::aws:policy/AdministratorAccess" : var.role_policies[count.index]
  lifecycle {
    ignore_changes = [policy_arn]
  }
  depends_on = [aws_iam_role.roles]
}

resource "aws_iam_role_policy_attachment" "conditional_policy_attachment" {
  count      = length([for policy in var.role_policies : policy if policy != ""])
  role       = aws_iam_role.roles[count.index].name
  policy_arn = var.role_policies[count.index]
  lifecycle {
    ignore_changes = [policy_arn]
  }
  depends_on = [aws_iam_role.roles]
}
