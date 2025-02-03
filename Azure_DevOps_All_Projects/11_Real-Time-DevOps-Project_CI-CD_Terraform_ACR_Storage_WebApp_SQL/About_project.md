# <span style="color: Yellow;"> CI/CD Pipeline for Private AKS: Integrating Azure DevOps, Terraform, Private ACR, Azure SQL DB, Application Gateway, Azure Key Vault, and Azure Storage Account

![Image](https://github.com/user-attachments/assets/00ba4653-adaa-4422-b3b1-fb94654c4f2a)

This document describes the process of setting up a CI/CD pipeline using Azure DevOps, Terraform, and various Azure services for deploying a web application on a private AKS cluster. The deployment is automated and ensures secure communication between services.

## Prerequisites

Before diving into this project, here are some skills and tools you should be familiar with:

Need to create a PAT access Token-

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/10_Real-Time-DevOps-Project_CI-CD_Terraform_ACR_Storage_WebApp)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
    - Update ```terraform.tfvars```
     
- [x] [Infra as Code](https://github.com/mrbalraj007/infra-as-code.git)
- [x] [Application Repo](https://github.com/mrbalraj007/etickets.git)

1. **Azure Subscription**: An active Azure subscription is required to create and manage resources.
2. **Azure DevOps Account**: An Azure DevOps account to create and manage pipelines.
3. **Terraform**: Installed on the local machine or configured in the Azure DevOps pipeline.
4. **Azure CLI**: Installed on the local machine or configured in the Azure DevOps pipeline.
5. **Service Principal**: Created in Azure AD for authentication and authorization in the pipeline.

## Technologies/Services Used

1. **Azure Kubernetes Service (AKS)**: For deploying the web application in a private cluster.
2. **Azure SQL Database**: For storing application data.
3. **Azure Container Registry (ACR)**: For storing Docker images.
4. **Azure Application Gateway**: For load balancing and routing traffic to the AKS cluster.
5. **Azure Virtual Network (VNet)**: For isolating resources and enabling secure communication.
6. **Azure Private Endpoint**: For secure access to Azure services within the VNet.
7. **Azure Key Vault**: For storing secrets and sensitive information.
8. **Azure Log Analytics Workspace**: For collecting and analyzing logs.
9. **Terraform**: For infrastructure as code to automate resource creation.
10. **Azure DevOps**: For creating CI/CD pipelines.

## Key Points

1. **Architecture Overview**:
   - The architecture includes multiple VNets for AKS, ACR, and self-hosted agents.
   - Virtual Network Peering is used to enable communication between VNets.
   - Private Endpoints are used for secure access to Azure services.

2. **Build Pipeline**:
   - The build pipeline includes tasks to build and push a Docker image to ACR.
   - Terraform configuration files are published as pipeline artifacts for use in the release pipeline.

3. **Release Pipeline**:
   - The release pipeline is linked to the artifacts published by the build pipeline.
   - It includes stages for deploying resources to AKS using Terraform.
   - Auto-scaling and alert configurations are set up for the web app.

4. **Terraform Configuration**:
   - Separate files for providers, variables, and main configuration.
   - Variables are stored securely and referenced in the configuration files.
   - The configuration includes creating VNets, AKS cluster, ACR, SQL Database, Application Gateway, and Private Endpoints.

5. **Service Connections**:
   - Azure DevOps service connections are created for authentication with Azure and Docker Registry.

## <span style="color: Yellow;">Setting Up the Infrastructure </span>

First, we'll create the necessary virtual machines using ```terraform``` code. 

Below is a terraform Code:

Once you [clone repo](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/10_Real-Time-DevOps-Project_CI-CD_Terraform_ACR_Storage_WebApp)</span> and run the terraform command.
```bash
$ ls -l
-rw-r--r-- 1 bsingh 1049089  690 Jan 31 15:01 DevOps_UI.tf
-rw-r--r-- 1 bsingh 1049089 6115 Jan 31 15:01 group_lib.tf
-rw-r--r-- 1 bsingh 1049089 3011 Jan 29 09:47 KeyVault_Create_permission.tf
-rw-r--r-- 1 bsingh 1049089  921 Jan 24 13:03 KeyVault-Getdata.tf
-rw-r--r-- 1 bsingh 1049089  675 Jan 30 11:41 output.tf
-rw-r--r-- 1 bsingh 1049089  813 Jan 24 13:03 provider.tf
-rw-r--r-- 1 bsingh 1049089  326 Jan 24 13:03 ssh_key.tf
-rw-r--r-- 1 bsingh 1049089  924 Jan 30 11:29 Storage.tf
-rw-r--r-- 1 bsingh 1049089 4248 Jan 31 20:36 terraform.tfvars
-rw-r--r-- 1 bsingh 1049089 3727 Jan 30 11:58 variable.tf
```

You need to run the following terraform command.

Now, run the following command.
```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply 
# Optional <terraform apply --auto-approve>
```
![alt text](image.png)

Once you run the terraform command, then we will verify the following things to make sure everything is setup via a terraform.

### <span style="color: Orange;"> Inspect the ```Cloud-Init``` logs</span>: 
Once connected to VM then you can check the status of the ```user_data``` script by inspecting the log files
```bash
# Primary log file for cloud-init
sudo tail -f /var/log/cloud-init-output.log
                    or 
sudo cat /var/log/cloud-init-output.log | more
```
- *If the user_data script runs successfully, you will see output logs and any errors encountered during execution.*
- *If there’s an error, this log will provide clues about what failed.*


## Detailed Steps

1. **Setting Up the Architecture**:
   - **Azure Repos**: Store the source code and Terraform configuration files.
   - **Azure Storage Account**: Store the Terraform state file securely.
   - **Build Pipeline**: Configure tasks to build and push Docker images.
   - **Release Pipeline**: Configure tasks to deploy resources using Terraform.

2. **Configuring the Build Pipeline**:
   - **Build and Push Docker Image**: Use Docker to build the application image and push it to ACR.
   - **Publish Terraform Files**: Publish Terraform configuration files as pipeline artifacts.

3. **Configuring the Release Pipeline**:
   - **Initialize Terraform**: Initialize the Terraform working directory and download necessary plugins.
   - **Apply Terraform Configuration**: Apply the Terraform configuration to create resources in Azure.
   - **Deploy Web App**: Deploy the Docker image to AKS.
   - **Configure Auto-Scaling and Alerts**: Set up auto-scaling rules and alert notifications.

4. **Terraform Configuration Files**:
   - **Provider Configuration**: Define the Azure provider and authentication details.
   - **Variable Definitions**: Define variables for resource names, locations, and other configurations.
   - **Main Configuration**: Define the resources to be created, including VNets, AKS cluster, ACR, SQL Database, Application Gateway, and Private Endpoints.

5. **Creating Service Connections**:
   - **Azure Service Connection**: Authenticate with Azure for deploying resources.
   - **Docker Registry Service Connection**: Authenticate with ACR for pushing Docker images.

### <span style="color: Yellow;"> Step-by-Step Process:</span>

#### <span style="color: cyan;"> Configure Service Connection
- First create [Service Connection](https://www.youtube.com/watch?v=pSmKNbN_Y4s) in Azure Devops.
- Once you create a connection then note it down the connection Name, because that name would be used in pipeline. 
- On agent machine, make sure login with azure login and connection is active, if not then login with following.
  ```sh
  az login --use-device-code
  ```
- Need to Create a service Connect in pipeline first.
     - Azure Service Connection
![alt text](image-1.png)
![alt text](image-2.png)
![alt text](image-3.png)
![alt text](image-4.png)
![alt text](image-5.png)
![alt text](image-6.png)

#### <span style="color: cyan;"> Update Secret variable value details.
- Update secret variable value first
  - update `servicePrincipalId`
  - update `servicePrincipalKey`
  - update `tenantid`

- **Step-01**. Go to keyvault and update the value (Azure UI)
  ![alt text](image-7.png)
  ![alt text](image-8.png)
  ![alt text](image-9.png)

- Update rest of two values in a same ways.
  
- **Step-02**. Update the secret in Library at Azure DevOps 
![alt text](image-10.png)

- **Step-03**. Link secrets from an Azure key vault as variables..
![alt text](image-11.png)
![alt text](image-12.png)
![alt text](image-13.png)
![alt text](image-14.png)
![alt text](image-15.png)
![alt text](image-16.png)

#### <span style="color: cyan;"> Update changes in Repo code as per project details.
- Repo (Infra-as-code)
  - Step-01: `script file` need to be updated from  `agent-vm` folder
    - update the `Organization` and `PAT token`
   ![alt text](image-17.png)


  - Step-02: Update Service Principle Name from `private-acr` Folder
    - To get the Service Principal name
      - List Service Principals:
    ```sh
    az ad sp list --query <query_string>

    Example:
    az ad sp list --query "[].{Name:displayName, AppId:appId}" --output table

    # filder with name for your service account
    az ad sp list --query "[?starts_with(displayName, 'Azure')].{Name:displayName, AppId:appId}" --output table
    ```
    - Update the Service Principal name:
    ![alt text](image-18.png)

### <span style="color: yellow;"> Build a YAML pipeline.
- Step-01: Build YAML pipeline as below:
![alt text](image-19.png)
![alt text](image-20.png)
![alt text](image-21.png)
![alt text](image-22.png)

- Adjust the paramerts for `vNet` Job.
   - ![alt text](image-23.png)

- Adjust the paramerts for `vm` Job.
  ![alt text](image-24.png)

- Adjust the paramerts for `acr` Job.
![alt text](image-25.png)

- Save and run the pipeline.
![alt text](image-26.png)

- Adjust the paramerts for `db` Job.
![alt text](image-27.png)

- Adjust the paramerts for `appgateway` Job.
![alt text](image-28.png)

- Adjust the `ssh key` in library for `AKS cluster`
  - `SSH public key` need to be updated
   ![alt text](image-29.png)

  Run the pipeline.
  ![alt text](image-37.png)


### <span style="color: yellow;"> Install SQL package on Agent VM.
- Open a PuTTY session for the virtual machine and install the required SQL package to check SQL connectivity.

  - install mssql-tools
    - sudo apt-get update
    - sudo apt-get install mssql-tools -y
  
  - Find the sqlcmd executable:
    - ls /opt/mssql-tools/bin/sqlcmd
  
  - Add the sqlcmd directory to your PATH:
    - nano ~/.bashrc
    - export PATH="$PATH:/opt/mssql-tools/bin"
  
  - Apply the changes:
    - source ~/.bashrc
  
  ![alt text](image-30.png)

  - Verify the installation:
    - sqlcmd -S <server_address> -U <username> -P <password> -d <database_name>
  ![alt text](image-31.png)


- Convert SQL cred to base 64  
```
echo "Server=tcp:yourserver.database.windows.net,1433;Initial Catalog=yourdatabase;Persist Security Info=False;User ID=yourusername;Password=yourpassword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;" | base64
```
![alt text](image-33.png)

- Decode base64 cred to Normal.
```sh
 echo "U2VydmVyPXRjcDpldGlja2V0ZGJzZXJ2ZXIzMDAxMjAyNS5kYXRhYmFzZS53aW5kb3dzLm5ldCwxNDMzO0luaXRpYWwgQ2F0YWxvZz1ldGlja2V0cy1kYjtQZXJzaXN0IFNlY3VyaXR5IEluZm89RmFsc2U7VXNlciBJRD1henVyZXVzZXI7UGFzc3dvcmQ9cGFzc3dvcmRAMTIzO011bHRpcGxlQWN0aXZlUmVzdWx0U2V0cz1GYWxzZTtFbmNyeXB0PVRydWU7VHJ1c3RTZXJ2ZXJDZXJ0aWZpY2F0ZT1G" | base64 -d
```

![alt text](image-32.png)

###  <span style="color: yellow;"> Connect `AKS cluster` on Agent VM.
- Run the following commands to connect AKS cluster
  - Login to your azure account
  ```sh
  az login
  ```
  - Set the cluster subscription
  ```sh
  az account set --subscription <ID>
  ```
  - Download cluster credentials
  ```sh
  az aks get-credentials --resource-group rg-devops --name aksdemo --overwrite-existing
  ```

![alt text](image-34.png)

### <span style="color: yellow;"> Verify Application Accessibility.
- Try to access application gateway IP in browser and you will below error message
![alt text](image-35.png)
![alt text](image-36.png)

## <span style="color: yellow;">  Build the second pipeline (Application).

- Build application pipeline
![alt text](image-38.png)

- run the pipeline.

- It will ask for permission and approve it.
![alt text](image-39.png)


- Update the deployment.yaml file as below (SQL Connection)
  ![alt text](image-40.png)

- AKS deployment is waiting for approval
- ![alt text](image-41.png)

### <span style="color: yellow;"> Troubleshooting.
- I was getting an error `imagepullbackoff` and noticed that the `SQL connection` name was having a problem. To retrieve and update the string from Secret.
- Retrieve and Update Connection String from Secret
  - Since you're using a Kubernetes secret for the database connection, check the secret value:
  ```bash
  kubectl get secret db-connection-secret -o jsonpath="{.data.connection-string}" | base64 --decode
  ```
- Pipeline status
![alt text](image-46.png)

- Image status
![alt text](image-42.png)

### <span style="color: yellow;"> Update the image name in manifest file.
![alt text](image-40.png)


- Application is accessible now.
![alt text](image-43.png)

- Try to create account in website.
![alt text](image-44.png)

- Following are the cred to login into webpage
![alt text](image-45.png)

Congratulations :-) the application is working and accessible.


## <span style="color: yellow;"> Pipeline for Cleanup Infra Setup.</span>
- Following are the sequence to delete the setup using pipeline.
  - AKS Cluster
  - Application Gateway
  - Azure Container Registry
  - SQL Database
  - Agent VM
  - VNet
  
- Here is the 👉[Updated pipeline]()👈 

## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete `ssh_key`, `Vault` and `Storage account`.

- Run the terraform command.
  ```bash
  Terraform destroy --auto-approve
  ```

- I was getting below error message while deleting the setup
![alt text](image-47.png)

- Rerun the destroy command again and it will delete `ResourceGroup` as well.
![alt text](image-48.png)


## <span style="color: Yellow;"> Conclusion

This project demonstrates a robust CI/CD pipeline setup using Azure DevOps, Terraform, and various Azure services. By automating the deployment process, it ensures efficient, scalable, and secure deployment of a web application on a private AKS cluster. The use of Terraform for infrastructure as code provides flexibility and ease of management, making it a valuable approach for modern cloud-based applications.


__Ref Link:__


- [YouTube Link](https://www.youtube.com/watch?v=PDBoprlJfUw)
- [Standard and Basic SKU](https://learn.microsoft.com/en-us/answers/questions/1349124/azure-cannot-change-the-static-ip-address)
- [Terraform code for azurerm_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip)
- [Terraform code for azurerm_kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/2.17.0/docs/resources/kubernetes_cluster)
- [AKS cluster_node_pool](https://registry.terraform.io/providers/hashicorp/azurerm/2.48.0/docs/resources/kubernetes_cluster_node_pool)
- [Kubernetes versions details ](https://learn.microsoft.com/en-us/azure/aks/supported-kubernetes-versions?tabs=azure-cli#supported-version-list)
- [Billing FAQs](https://learn.microsoft.com/en-us/azure/devops/organizations/billing/billing-faq?view=azure-devops&viewFallbackFrom=vsts&tabs=new-nav)
