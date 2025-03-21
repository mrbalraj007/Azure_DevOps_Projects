aws_region = "us-east-1"

role_names = ["SINGH-Admin", "SINGH-IAM", "SINGH-CLI", "SINGH-Others"]

assume_role_policy_version = "2012-10-17"
assume_role_policy_action  = "sts:AssumeRole"
assume_role_policy_effect  = "Allow"
assume_role_policy_service = "ec2.amazonaws.com"
