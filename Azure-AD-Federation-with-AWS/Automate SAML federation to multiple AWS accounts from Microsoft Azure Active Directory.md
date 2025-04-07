# Zero Trust Identity: Implementing Azure AD Federation with AWS IAM Roles
<!-- Azure AD Federation with AWS: Technical Implementation Guide -->

## 0. Introduction to Federation Architecture
Federation enables centralized user authentication across multiple service providers through a trusted identity provider. This document outlines the implementation of SAML 2.0-based federation between Azure Active Directory (Azure AD) and Amazon Web Services (AWS), allowing users to authenticate to AWS using their Azure AD credentials.
      ![alt text](All_ScreenShot/image-50.png)

## 1. Federation Benefits

- **Centralized Identity Management**: Maintains a single source of truth for user identities
- **Enhanced Security Posture**: Eliminates the need for multiple credentials across systems
- **Streamlined Access Management**: Enables role-based access control (RBAC) through Azure AD groups
- **Operational Efficiency**: Reduces administrative overhead for user provisioning and deprovisioning

## 2. Architectural Overview

[Azure AD AWS Federation Architecture](https://aws.amazon.com/blogs/security/how-to-automate-saml-federation-to-multiple-aws-accounts-from-microsoft-azure-active-directory/)

The federation architecture consists of:
- **Identity Provider (IdP)**: Azure Active Directory
- **Service Provider (SP)**: AWS
- **Authentication Protocol**: SAML 2.0
- **Token Exchange**: STS (Security Token Service) for temporary credential issuance

## 3. Authentication Flow
<!-- 
1. User requests access to AWS via a SAML endpoint URL
2. User authenticates against Azure AD
3. Azure AD generates a SAML assertion containing user attributes and role mappings
4. The SAML assertion is posted to AWS SSO endpoint
5. AWS validates the SAML assertion against the configured IdP
6. AWS STS issues temporary security credentials for the mapped IAM role
7. User is redirected to AWS Management Console with appropriate permissions -->


**Detailed Workflow Steps**:
01. **User Initiates Login:** The user starts the login process, typically by accessing an application or service that requires authentication.
02. **Azure AD Authenticates User:** Azure Active Directory (Azure AD) verifies the user's credentials.
03. **Azure AD Sends Token:** Upon successful authentication, Azure AD issues a token to the user.
04. **AWS SSO Validates Token:** The token is sent to AWS Single Sign-On (SSO), which validates it against the configured identity provider.
05. **AWS Identity Provider Issues Temporary Credentials:** AWS Identity Provider (IdP) issues temporary security credentials via AWS Security Token Service (STS).
06. **AWS STS Provides Access:** These temporary credentials grant the user access to AWS resources.
07. **User Accesses Resources:** The user can now interact with the AWS resources they have permissions for.
08. **Application/Service Returns Response:** The application or service processes the user's request and returns the appropriate response.
09. **CloudTrail Logs Activity:** AWS CloudTrail logs all activities for auditing and monitoring purposes.
10. **Security Team Monitors and Audits:** The security team reviews logs and monitors for any suspicious activities.
11. **User Logs Out:** The user logs out, ending the session.

## 4. Prerequisites

- [x] [Terraform code](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure-AD-Federation-with-AWS/Terraform-Code-AWS_Roles)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
    - Update ```terraform.tfvars```
    
## 5. Implementation Procedure

### <span style="color: Yellow;"> 5.1 Azure AD Configuration

#### 5.1.1 Register Enterprise Application for AWS

1. Navigate to Azure Portal > Search for "`Microsoft Entra ID`" > Enterprise applications
2. Select "`New application`"

   ![alt text](All_ScreenShot/image.png)
   ![alt text](All_ScreenShot/image-1.png)
3. in the Search page filter with "`Categories: Developer Services`"
![alt text](All_ScreenShot/image-2.png)
4. Search for "Amazon Web Services" (non-Console version)
![alt text](All_ScreenShot/image-3.png)
5. Provide a name for the application and add it
![alt text](All_ScreenShot/image-4.png)

#### 5.1.2 Configure SAML SSO
> **Note:** AWS SSO does not support automatic SCIM provisioning from Azure AD.
1. In the enterprise application, navigate to "Single sign-on"
![alt text](All_ScreenShot/image-5.png)
2. Select "SAML" as the authentication method
![alt text](All_ScreenShot/image-6.png)
3. It will prompt for save setting, click on `Yes`. 
![alt text](All_ScreenShot/image-7.png)
![alt text](All_ScreenShot/image-8.png)
> note:: Refresh the page and you will noticed that `identifier (Entity ID)` is auto added.
![alt text](All_ScreenShot/image-9.png)

> *If you don't found `Attributes & Claims` is not updated automaticaly then you have to following `steps (5.1.3)`*

4. Download the Federation Metadata XML file for use in AWS configuration
![alt text](All_ScreenShot/image-10.png)

#### 5.1.3 Configure User `Attributes and Claims` (Optional)
Configure the following SAML attributes & claims:

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

### <span style="color: Yellow;"> 5.2 AWS Configuration

I have created a Terraform code to set up the Identity providers, including the `Roles, Policy,` and `User` automatically created.

First, we'll create the necessary virtual machines using ```terraform``` code. 

  - Below is a terraform Code:

    - Once you [clone repo](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure-AD-Federation-with-AWS/Terraform-Code-AWS_Rolese)</span> and run the terraform command.
        ```bash
        $ ls -l
           -rw-r--r-- 1 bsingh 1049089  2200 Apr  7 09:00 aws.tf
           -rw-r--r-- 1 bsingh 1049089  2451 Apr  7 09:12 output.tf
           -rw-r--r-- 1 bsingh 1049089 13978 Apr  4 17:22 saml_metadata.xml
           -rw-r--r-- 1 bsingh 1049089   548 Apr  7 09:17 terraform.tfvars
           -rw-r--r-- 1 bsingh 1049089  1522 Apr  7 09:00 variables.tf
        ```

  - You need to run terraform command.
    - Run the following command.
        ```bash
        terraform init
        terraform fmt
        terraform validate
        terraform plan
        terraform apply 
        # Optional <terraform apply --auto-approve>
        ```
  ![alt text](All_ScreenShot/image-11.png)

***Once you run the terraform command, then we will verify the following things to make sure everything is setup via a terraform.***

### <span style="color: cyan;"> Verify the `Identity providers` 
![alt text](All_ScreenShot/image-12.png)
![alt text](All_ScreenShot/image-13.png)

### <span style="color: cyan;"> Verify the `Policy` 
![alt text](All_ScreenShot/image-14.png)
### <span style="color: cyan;"> Verify the `Roles`
![alt text](All_ScreenShot/image-15.png)
### <span style="color: cyan;"> Verify the `Users`
![alt text](All_ScreenShot/image-16.png)

#### 5.2.1 Create SAML Identity Provider

1. Sign in to AWS Management Console
2. Navigate to IAM > Identity providers
3. Select existing SAML provider:
   - Provider name: (e.g., `AzureAD-SAML-Provider`)
   - Click on Replace metadata
   ![alt text](All_ScreenShot/image-18.png)
   - To confirm replacement, type `confirm` in the field.
   ![alt text](All_ScreenShot/image-19.png)

   - Upload the metadata document from Azure AD
   ![alt text](All_ScreenShot/image-20.png)


#### 5.2.2 Create IAM Roles for Federation
0. Verify the existing roles.
> *Note: If above roles doesn't work then create the new role with help of the following steps.*
1. Navigate to IAM > Roles
2. Create role for SAML 2.0 federation:
   - Select your SAML identity provider
   - Enable both programmatic and AWS Management Console access
   - Select appropriate permissions policies (e.g., AdministratorAccess, AmazonS3ReadOnlyAccess)
   - Name the role appropriately (e.g., AzureAD-Admin, AzureAD-S3ReadOnly)

#### 5.2.3 Create `access` and `secret` keys for user `AzureSSOUser`

- User> Security Credentials> `Create Access Key`
![alt text](All_ScreenShot/image-21.png)
![alt text](All_ScreenShot/image-22.png)
![alt text](All_ScreenShot/image-23.png)
![alt text](All_ScreenShot/image-24.png)

- Download the `.csv file`

### 5.3 Azure AD Group and Role Mapping

#### 5.3.1 Create Azure AD Groups

1. Navigate to Azure Active Directory > Groups
2. Create groups corresponding to AWS roles (e.g., AWS-Admin, AWS-S3ReadOnly)

> **Note**: *I don't have P1/P2 license so I'll demonistrate in basic account and will use user account for demonstration.*

#### 5.3.2 Configure Provisioning Role
1. Navigate to Microsoft Entra ID > Manage > Enterprise Applications >
![alt text](All_ScreenShot/image-25.png)

2. Select `Provisioning` from manage.
![alt text](All_ScreenShot/image-26.png)
![alt text](All_ScreenShot/image-27.png)
3. Select the provisioning mode to `Automatic` from `Manual`.
![alt text](All_ScreenShot/image-28.png)
4. Select `Admin Credentials` and put `access` and `secret` keys for user which we have created in AWS.
![alt text](All_ScreenShot/image-29.png)
5. Click on `Test Connection`.
![alt text](All_ScreenShot/image-30.png)
> I was getting an error message while validating the connection.

##### <span style="color: Red;"> **Troubleshooting**:  
   - **Fixed**:  
      - I noticed that I was using these permission [`s3:ListBucket", "s3:GetObject", "ec2:DescribeInstances`] in custom policy while I should use [`iam:ListRoles`].
      - I have updated the terraform code for updated policy. 
6. Now, click on the `Test Connection` and `Save`.       
![alt text](All_ScreenShot/image-31.png)

7. Refesh the page and change the `provisioning state` to `on` from off.
![alt text](All_ScreenShot/image-32.png)
8. Click on `Save`.

#### 5.3.3 Verify the Role status of Provisioning
1. Navigate to Microsoft Entra ID > Manage > Enterprise Applications > Provisioning.
   - Click on `Overview` from the `Provisioning` page for Role Sync.
   ![alt text](All_ScreenShot/image-33.png)


#### 5.3.4 Configure Application Role Assignments
<!-- 
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
   ``` -->

1. Assign users or groups to these roles in the enterprise application:
   - Navigate to Enterprise application > Users and groups
   ![alt text](All_ScreenShot/image-34.png)
   ![alt text](All_ScreenShot/image-35.png)
   - Add users/groups and assign appropriate roles
   ![alt text](All_ScreenShot/image-36.png)
   ![alt text](All_ScreenShot/image-37.png)
   ![alt text](All_ScreenShot/image-38.png)
   ![alt text](All_ScreenShot/image-39.png)
### 5.4 Testing the Federation

1. Access the User Access URL from Enterprise Application properties
![alt text](All_ScreenShot/image-40.png)
 or try with following URL
[`https://myapplications.microsoft.com/`] 
2. Sign in with Azure AD credentials
![alt text](All_ScreenShot/image-41.png)
![alt text](All_ScreenShot/image-42.png)
3. If assigned multiple roles, select the desired role
![alt text](All_ScreenShot/image-43.png)
> I am getting the above error.

##### <span style="color: Red;"> **Troubleshooting**:  
   - **Fixed**:  
      - I noticed that I was using the following `Trusted Entities` in Role and I removed it. 
         ![alt text](All_ScreenShot/image-44.png)

      Now `Trusted Entities` in Role as below
      ![alt text](All_ScreenShot/image-45.png)   
      - I have updated the terraform code for updated policy. 

4. I retied to access the page again and issue got resolved. assigned multiple roles are visible, select the desired role
![alt text](All_ScreenShot/image-47.png)

5. Verify successful redirection to AWS Management Console with appropriate permissions.
![alt text](All_ScreenShot/image-46.png)

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

## 9. <span style="color: Yellow;"> Environment Cleanup:
- Azure
  1. Navigate to Microsoft Entra ID > App Registrations
   ![alt text](All_ScreenShot/image-48.png)
  2. Select `AWS Single-Account Access` application
  3. Delete application
   ![alt text](All_ScreenShot/image-49.png)
- AWS
  - As we are using Terraform, we will use the following command to delete `AWS Setup`.  

  - Run the terraform command.
     ```bash
     Terraform destroy --auto-approve
     ```

**Ref Link**

- [YouTube Link](https://www.youtube.com/watch?v=F33pP_eCl50&list=PLJcpyd04zn7rxl0X8mBdysb5NjUGIsJ7W&index=29)
- https://learn.microsoft.com/en-us/entra/identity/saas-apps/amazon-web-service-tutorial
- https://learn.microsoft.com/en-us/entra/identity-platform/reference-microsoft-graph-app-manifest
- https://docs.aws.amazon.com/IAM/latest/UserGuide/troubleshoot_saml.html#troubleshoot_saml_missing-role
- https://office365itpros.com/2022/03/23/delete-entra-id-user-accounts/
- https://docs.redhat.com/en/documentation/ansible_on_clouds/2.x/html-single/
- https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-provisioning-logs
- https://nabotpaldash.home.blog/2019/09/28/azure-ad-with-multiple-aws-accounts-seamlessly/
********************
