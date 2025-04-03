# Azure AD Federation with AWS: Technical Implementation Guide

## 1. Introduction to Federation Architecture
Federation enables centralized user authentication across multiple service providers through a trusted identity provider. This document outlines the implementation of SAML 2.0-based federation between Azure Active Directory (Azure AD) and Amazon Web Services (AWS), allowing users to authenticate to AWS using their Azure AD credentials.

## 2. Federation Benefits

- **Centralized Identity Management**: Maintains a single source of truth for user identities
- **Enhanced Security Posture**: Eliminates the need for multiple credentials across systems
- **Streamlined Access Management**: Enables role-based access control (RBAC) through Azure AD groups
- **Operational Efficiency**: Reduces administrative overhead for user provisioning and deprovisioning

## 3. Architectural Overview

![Azure AD AWS Federation Architecture]

The federation architecture consists of:
- **Identity Provider (IdP)**: Azure Active Directory
- **Service Provider (SP)**: AWS
- **Authentication Protocol**: SAML 2.0
- **Token Exchange**: STS (Security Token Service) for temporary credential issuance

## 4. Authentication Flow

1. User requests access to AWS via a SAML endpoint URL
2. User authenticates against Azure AD
3. Azure AD generates a SAML assertion containing user attributes and role mappings
4. The SAML assertion is posted to AWS SSO endpoint
5. AWS validates the SAML assertion against the configured IdP
6. AWS STS issues temporary security credentials for the mapped IAM role
7. User is redirected to AWS Management Console with appropriate permissions

## 5. Implementation Procedure

### 5.1 Azure AD Configuration

#### 5.1.1 Register Enterprise Application for AWS

1. Navigate to Azure Portal > Azure Active Directory > Enterprise applications
2. Select "New application"
3. Search for "Amazon Web Services" (non-Console version)
4. Provide a name for the application and add it

#### 5.1.2 Configure SAML SSO

1. In the enterprise application, navigate to "Single sign-on"
2. Select "SAML" as the authentication method
3. Configure the following SAML attributes:

#### 5.1.3 Configure User Attributes and Claims

Configure the following SAML claims:

1. **Role Claim**:
   - Name: `https://aws.amazon.com/SAML/Attributes/Role`
   - Source: Attribute
   - Source attribute: `user.assignedroles`

2. **Session Duration**:
   - Name: `https://aws.amazon.com/SAML/Attributes/SessionDuration`
   - Value: `3600` (or desired duration in seconds)

3. **Session Name**:
   - Name: `https://aws.amazon.com/SAML/Attributes/RoleSessionName`
   - Source: Attribute
   - Source attribute: `user.objectid` (or `user.userprincipalname`)

4. Download the Federation Metadata XML file for use in AWS configuration

### 5.2 AWS Configuration

#### 5.2.1 Create SAML Identity Provider

1. Sign in to AWS Management Console
2. Navigate to IAM > Identity providers
3. Create a new SAML provider:
   - Provider name: (e.g., AzureAD)
   - Upload the metadata document from Azure AD
   - Create provider

#### 5.2.2 Create IAM Roles for Federation

1. Navigate to IAM > Roles
2. Create role for SAML 2.0 federation:
   - Select your SAML identity provider
   - Enable both programmatic and AWS Management Console access
   - Select appropriate permissions policies (e.g., AdministratorAccess, AmazonS3ReadOnlyAccess)
   - Name the role appropriately (e.g., AzureAD-Admin, AzureAD-S3ReadOnly)

### 5.3 Azure AD Group and Role Mapping

#### 5.3.1 Create Azure AD Groups

1. Navigate to Azure Active Directory > Groups
2. Create groups corresponding to AWS roles (e.g., AWS-Admin, AWS-S3ReadOnly)

#### 5.3.2 Configure Application Role Assignments

1. Edit the application manifest to include role mappings:
   ```json
   {
     "appRoles": [
       {
         "allowedMemberTypes": ["User", "Group"],
         "displayName": "Admin",
         "id": "[generate-guid]",
         "isEnabled": true,
         "description": "AWS Administrator access",
         "value": "arn:aws:iam::[account-id]:role/AzureAD-Admin,arn:aws:iam::[account-id]:saml-provider/AzureAD"
       },
       {
         "allowedMemberTypes": ["User", "Group"],
         "displayName": "S3ReadOnly",
         "id": "[generate-guid]",
         "isEnabled": true,
         "description": "AWS S3 Read-Only access",
         "value": "arn:aws:iam::[account-id]:role/AzureAD-S3ReadOnly,arn:aws:iam::[account-id]:saml-provider/AzureAD"
       }
     ]
   }
   ```

2. Assign users or groups to these roles in the enterprise application:
   - Navigate to Enterprise application > Users and groups
   - Add users/groups and assign appropriate roles

### 5.4 Testing the Federation

1. Access the User Access URL from Enterprise Application properties
2. Sign in with Azure AD credentials
3. If assigned multiple roles, select the desired role
4. Verify successful redirection to AWS Management Console with appropriate permissions

## 6. License Requirements

- **Azure AD P1**: Supports user-based SAML application assignments
- **Azure AD P2**: Required for group-based SAML application assignments
  - Recommended for enterprise deployments
  - Enables dynamic group membership and conditional access features

## 7. Security Considerations

- Implement appropriate session duration based on organizational security policies
- Consider using conditional access policies in Azure AD Premium
- Regularly audit role assignments in both Azure AD and AWS
- Monitor federation activity through Azure AD sign-in logs and AWS CloudTrail

## 8. Troubleshooting

- Verify SAML claim configurations if role assumption fails
- Check role ARN and identity provider ARN syntax in Azure AD role mappings
- Ensure users have appropriate group memberships in Azure AD
- Review AWS identity provider trust configuration

By implementing this federation architecture, organizations can centralize authentication and authorization while maintaining fine-grained access control to AWS resources.

**Ref Link**

- [YouTube Link](https://www.youtube.com/watch?v=we6HP4S-rWg&list=PLJcpyd04zn7rxl0X8mBdysb5NjUGIsJ7W&index=31)
- https://learn.microsoft.com/en-us/entra/identity/saas-apps/amazon-web-service-tutorial
- https://learn.microsoft.com/en-us/entra/identity-platform/reference-microsoft-graph-app-manifest
- https://docs.aws.amazon.com/IAM/latest/UserGuide/troubleshoot_saml.html#troubleshoot_saml_missing-role
- https://office365itpros.com/2022/03/23/delete-entra-id-user-accounts/
- https://docs.redhat.com/en/documentation/ansible_on_clouds/2.x/html-single/
- https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-provisioning-logs
- https://nabotpaldash.home.blog/2019/09/28/azure-ad-with-multiple-aws-accounts-seamlessly/