# Azure AD Federation with AWS

This project sets up federation between Azure Active Directory and AWS, allowing for Single Sign-On (SSO) authentication.

## Provisioning Users

**Note**: AWS SSO does not support automatic SCIM provisioning from Azure AD. The following error message in the Azure portal is expected:

> Out of the box automatic provisioning to AWS_SSO_Enterprise_App is not supported today. Ensure that AWS_SSO_Enterprise_App supports the SCIM standard for provisioning and request support for the application as described here. To determine if the application supports SCIM, please contact the application developer.

### How to Provision Users Instead

1. **Azure AD User/Group Assignment**
   - Go to the Enterprise Application in Azure AD
   - Navigate to "Users and groups"
   - Add users or groups
   - Assign them to the appropriate app role (Admin or ReadOnly)

2. **Role Mapping**
   - Admin role maps to the AADAdmin AWS role (with AdministratorAccess)
   - ReadOnly role maps to the AADS3RO AWS role (with ViewOnlyAccess and S3ReadOnlyAccess)

3. **SSO Experience**
   - Users will authenticate through Azure AD
   - Based on their assigned role, they will have access to the corresponding AWS role
   - No additional user provisioning is required in AWS

## Accessing AWS

1. Users sign in to Azure AD/Microsoft 365
2. Navigate to the My Apps portal or use the direct SSO URL
3. Click on the AWS SSO application
4. They will be redirected to AWS with appropriate permissions

## Deployment Instructions

### Single-Step Deployment

Deploy all resources with a single command:

```bash
cd path/to/project
terraform init
terraform apply
```

This will create:
1. An Azure AD Enterprise Application with SAML SSO configuration
2. An AWS SAML Identity Provider
3. AWS IAM roles for federation

## Manual Configuration Steps After Deployment

Some configuration steps must be done manually in the Azure Portal after deployment:

### Configure SAML Attributes

1. Go to Azure Portal > Enterprise Applications > AWS_SSO_Enterprise_App > Single sign-on
2. Set "Identifier (Entity ID)" to "https://signin.aws.amazon.com/saml"
3. Under "User Attributes & Claims", add these attribute mappings:

| Name | Source attribute | Namespace |
|------|-----------------|-----------|
| RoleSessionName | user.userprincipalname | https://aws.amazon.com/SAML/Attributes |
| Role | user.assignedroles | https://aws.amazon.com/SAML/Attributes |
| SessionDuration | user.sessionduration | https://aws.amazon.com/SAML/Attributes |

These attributes are essential for proper AWS role mapping:
- **RoleSessionName**: Identifies the user in AWS CloudTrail logs
- **Role**: Maps to the AWS IAM role ARNs the user can assume
- **SessionDuration**: Sets how long the AWS console session remains active (in seconds)

### Complete Role Mapping

For the Role attribute to work correctly, the value must have the format:
```
arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME,arn:aws:iam::ACCOUNT_ID:saml-provider/PROVIDER_NAME
```

Example:
```
arn:aws:iam::123456789012:role/AADAdmin,arn:aws:iam::123456789012:saml-provider/AzureAD_SAML_Provider
```

## Architecture

- **Azure**: Enterprise application with SAML SSO configuration
- **AWS**: SAML Identity Provider and IAM roles for federation

## Verification

After deployment, verify the integration:

1. In Azure AD, ensure the enterprise application is created
2. In AWS, verify the SAML provider exists
3. Test SSO login from Azure to AWS

## Troubleshooting

### Application Not Visible in MyApplications Portal

If the enterprise app doesn't appear in https://myapplications.microsoft.com/:

1. **Verify User Assignment**:
   - The app is configured to require explicit user assignment
   - Users must be assigned to the application to see it

2. **Check Assignment Status**:
   - Go to Azure Portal > Enterprise Applications > AWS_SSO_Enterprise_App > Users and groups
   - Add users/groups and assign appropriate roles

3. **Refresh MyApplications**:
   - It may take a few minutes for new assignments to appear
   - Try refreshing or signing out/in to the MyApplications portal

4. **Verify App Settings**:
   - The app should have `visible_to_users = true` and `show_in_app_launcher = true`
   - These are configured in the Terraform code
