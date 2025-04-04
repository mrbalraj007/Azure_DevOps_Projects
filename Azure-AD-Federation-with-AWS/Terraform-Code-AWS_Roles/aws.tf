resource "aws_iam_saml_provider" "saml_provider" {
  name                   = "AzureAD-SAML-Provider"
  saml_metadata_document = file("saml_metadata.xml") // Replace with the path to your SAML metadata file
}

resource "aws_iam_role" "aws_admin" {
  name               = "AWS-Admin"
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
        },
        "StringLike": {
          "SAML:sub": "admin@example.com"
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
  name               = "AWS-RO"
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
        },
        "StringLike": {
          "SAML:sub": "readonly@example.com"
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
  name = "NewUser"
}

resource "aws_iam_policy" "custom_permission_policy" {
  name        = "CustomPermissionPolicy"
  description = "Custom policy for NewUser"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "ec2:DescribeInstances"
      ],
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
