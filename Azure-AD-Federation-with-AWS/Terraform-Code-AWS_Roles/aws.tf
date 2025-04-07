resource "aws_iam_saml_provider" "saml_provider" {
  name                   = var.saml_provider_name
  saml_metadata_document = file(var.saml_metadata_file_path)
}

resource "aws_iam_role" "aws_admin" {
  name               = var.admin_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${aws_iam_saml_provider.saml_provider.arn}"
      },
      "Action": "sts:AssumeRoleWithSAML",
      "Condition": {
        "StringEquals": {
          "SAML:aud": "https://signin.aws.amazon.com/saml"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "admin_policy_attachment" {
  role       = aws_iam_role.aws_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "aws_ro" {
  name               = var.readonly_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${aws_iam_saml_provider.saml_provider.arn}"
      },
      "Action": "sts:AssumeRoleWithSAML",
      "Condition": {
        "StringEquals": {
          "SAML:aud": "https://signin.aws.amazon.com/saml"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "readonly_policy_attachment" {
  role       = aws_iam_role.aws_ro.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}


resource "aws_iam_user" "new_user" {
  name = var.iam_user_name
}

resource "aws_iam_policy" "custom_permission_policy" {
  name        = var.custom_policy_name
  description = var.custom_policy_description
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ${jsonencode(var.custom_policy_actions)},
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "custom_permission_policy_attachment" {
  user       = aws_iam_user.new_user.name
  policy_arn = aws_iam_policy.custom_permission_policy.arn
}
