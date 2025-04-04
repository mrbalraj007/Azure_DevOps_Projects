# Azure AD and AWS SSO Integration

This project sets up Single Sign-On (SSO) between Azure AD and AWS using SAML.

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

## Architecture

- **Azure**: Enterprise application with SAML SSO configuration
- **AWS**: SAML Identity Provider and IAM roles for federation

## Verification

After deployment, verify the integration:

1. In Azure AD, ensure the enterprise application is created
2. In AWS, verify the SAML provider exists
3. Test SSO login from Azure to AWS
