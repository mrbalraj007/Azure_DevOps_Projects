aws_region = "us-east-1"

role_names = ["AWS_M_Admin", "AWS_M__CLI", "AWS_M_IAM", "AWS_M_Others"]

assume_role_policy_version = "2012-10-17"
assume_role_policy_action  = "sts:AssumeRole"
assume_role_policy_effect  = "Allow"
assume_role_policy_service = "ec2.amazonaws.com"

role_policies = [
  "arn:aws:iam::aws:policy/AdministratorAccess",
  "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
  "arn:aws:iam::aws:policy/IAMFullAccess",
  ""
]
