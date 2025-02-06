# <span style="color: Yellow;"> Comprehensive CI/CD Pipeline for Private AKS: Seamless Integration with Azure DevOps, FrontDoor, Terraform, Private ACR, Azure SQL DB, Application Gateway, Key Vault, and Storage Account

This document provides a detailed explanation of setting up a CICD pipeline for deploying a web application on a private AKS cluster, integrating with Azure SQL Database, Private Azure Container Registry (ACR), and Application Gateway using Terraform. Additionally, it covers the use of Azure Front Door for global load balancing and content delivery.

## Prerequisites

Before diving into this project, here are some skills and tools you should be familiar with:

Need to create a PAT access Token-

- [x] [Terraform code](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/11_Real-Time-DevOps-Project_CI-CD_Terraform_ACR_Storage_WebApp_SQL)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
    - Update ```terraform.tfvars```
- [x] Application Repo:     
    - [x] [Infra as Code](https://github.com/mrbalraj007/infra-as-code.git)
    - [x] [Application Repo](https://github.com/mrbalraj007/etickets.git)

## Tools and Technologies: Used

   - **Terraform**: Used for infrastructure as code to create and manage Azure resources.
   - **Azure DevOps**: For CICD pipeline and repository management.
   - **Docker**: For containerizing the application.
   - **Kubernetes**: For orchestrating the deployment of the application on AKS.
   - **Azure Front Door**: For global load balancing and content delivery.
   - **Azure Key Vault**: For storing secrets and sensitive information.
   - **Azure CLI**: For managing Azure resources from the command line.
   - **Azure Log Analytics Workspace**: For collecting and analyzing logs.
   - **Azure Private Endpoint**: For secure access to Azure services within the VNet.
   - **Azure Virtual Network (VNet)**: For isolating resources and enabling secure communication.
   - **Azure Application Gateway**: For load balancing and routing traffic to the AKS cluster.
   - **Azure Container Registry (ACR)**: For storing Docker images.
   - **Azure SQL Database**: For storing application data.
   - **Azure Kubernetes Service (AKS)**: For deploying the web application in a private cluster.
   
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

## Key Points
**Architecture Components**:
   - **Virtual Networks**: Three virtual networks (AKS vnet, ACR vnet, Agent vnet) are used to isolate resources.
   - **Private AKS Cluster**: Deployed within the AKS vnet.
   - **Application Gateway**: Integrated with the AKS cluster for load balancing.
   - **Private ACR**: Hosted within the ACR vnet.
   - **Self-hosted Agent**: A virtual machine in the Agent vnet configured as a self-hosted agent for Azure DevOps.
   - **Virtual Network Peering**: Enables communication between the virtual networks.
   - **Private Endpoints**: Used for secure communication between services.
   - **Private DNS Zones**: For name resolution within the virtual networks.
   - **Azure SQL Database**: Backend database for the application.
   - **Log Analytics Workspace**: For collecting and analyzing logs.
   - **Ingress Controller**: Integrated with Application Gateway for routing traffic to the pods.


## <span style="color: Yellow;">Setting Up the Infrastructure </span>

First, we'll create the necessary virtual machines using ```terraform``` code. 

Below is a terraform Code:

Once you [clone repo](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/11_Real-Time-DevOps-Project_CI-CD_Terraform_ACR_Storage_WebApp_SQL)</span> and run the terraform command.
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
![Image](https://github.com/user-attachments/assets/8747070b-baf2-404a-9894-656eaa027df4)

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

3. **Pipeline Stages**:
   - **Infrastructure Creation**: Using Terraform to create virtual networks, virtual machines, ACR, SQL Database, Application Gateway, and AKS cluster.
   - **Application Deployment**: Building and pushing Docker images to ACR, deploying the application to AKS, and configuring Ingress and Application Gateway.
   - **Database Configuration**: Setting up the SQL database and running migrations.
   - **Monitoring and Logging**: Configuring Log Analytics Workspace for monitoring.

4. **Azure Front Door**:
   - **Global Load Balancing**: Distributes traffic across multiple backend endpoints.
   - **Content Delivery Network (CDN)**: Caches and delivers static and dynamic content closer to users.
   - **SSL/TLS Termination**: Offloads encryption and decryption processes.
   - **Application Layer Security**: Provides protection against common web application threats.
   - **Session Affinity**: Ensures subsequent requests from the same client are directed to the same backend server.
   - **Health Monitoring and Failover**: Continuously monitors backend endpoints and reroutes traffic if necessary.


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
![Image](https://github.com/user-attachments/assets/e10917fd-fb50-4971-af44-092d36c49e3d)
![Image](https://github.com/user-attachments/assets/e2199467-ae79-4ad4-a679-cd7a5eb22610)
![Image](https://github.com/user-attachments/assets/8b5f1b92-0891-43c8-9a58-5ca27427952c)
![Image](https://github.com/user-attachments/assets/1e7020fc-8a7d-4c68-bb7a-9b101ce8dc55)
![Image](https://github.com/user-attachments/assets/ea313399-e8b3-402d-8cb1-875f6e698b27)
![Image](https://github.com/user-attachments/assets/1fe802f7-bb27-4df1-af33-9b1ca6d19188)

#### <span style="color: cyan;"> Update Secret variable value details.
- Update secret variable value first
  - update `servicePrincipalId`
  - update `servicePrincipalKey`
  - update `tenantid`

  - **Step-01**. Go to keyvault and update the value (Azure UI)
    ![Image](https://github.com/user-attachments/assets/641035f5-af9a-425b-a90c-77109f29da5a)
    ![Image](https://github.com/user-attachments/assets/d38fe4a1-7306-48f1-a4bd-5cc89bb8df54)
    ![Image](https://github.com/user-attachments/assets/0ef6df0e-e930-4a08-a7d2-4a541726b6b0)

- Update rest of two values in a same ways.
  
  - **Step-02**. Update the secret in Library at Azure DevOps 
    ![Image](https://github.com/user-attachments/assets/f06b8daa-65d8-4999-90a6-e222f61336ad)

  - **Step-03**. Link secrets from an Azure key vault as variables..
    ![Image](https://github.com/user-attachments/assets/3f1ee30c-c31e-47e4-b554-dd0367c185f2)
    ![Image](https://github.com/user-attachments/assets/7a8e2a60-2862-460e-aefd-e313a588a0b9)
    ![Image](https://github.com/user-attachments/assets/cda11888-d173-4c83-8bfa-440f00d5aaa2)
    ![Image](https://github.com/user-attachments/assets/00bf3b2c-4edc-4a1c-a7cd-c21b9232a5d1)
    ![Image](https://github.com/user-attachments/assets/8edb341d-47a4-4777-9af0-f9011e3a94b0)
    ![Image](https://github.com/user-attachments/assets/976fc27e-27b1-4118-bcc7-fa39cbc2e245)

#### <span style="color: cyan;"> Update changes in Repo code as per project details.
- Repo (Infra-as-code)
  - Step-01: `script file` need to be updated from  `agent-vm` folder
    - update the `Organization` and `PAT token`
    ![Image](https://github.com/user-attachments/assets/08b262af-bf4f-4a54-b9ee-ffe5e23b4778)


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
    ![Image](https://github.com/user-attachments/assets/7b9db8ed-2991-44e0-a79b-e80db59921ae)

### <span style="color: yellow;"> Build a YAML pipeline.
- Following are the sequence to create the setup using pipeline.
  - VNet (Network/Subnet)
  - Agent VM  
  - Azure Container Registry
  - SQL Database
  - Application Gateway
  - AKS Cluster
  - FrontDoor
  
- Step-01: Build YAML pipeline as below:
![Image](https://github.com/user-attachments/assets/ab364f80-8ca9-40c6-b049-66e96353d0c9)
![Image](https://github.com/user-attachments/assets/d8256fb6-02da-4e09-aa16-aca69699dd1e)
![Image](https://github.com/user-attachments/assets/264e7e8f-8074-46c1-84e9-69dfc3c684d5)
![Image](https://github.com/user-attachments/assets/32bceb0a-b008-49b0-b201-98edbd8cd7e4)


- Adjust the paramerts for `vNet` Job.
   ![Image](https://github.com/user-attachments/assets/fb6b8e3e-fb2a-405a-bf5a-7fbc2d9a1841)

- Adjust the paramerts for `vm` Job.
  ![Image](https://github.com/user-attachments/assets/28d63092-c966-4bb5-8869-8de0cefff925)

- Adjust the paramerts for `acr` Job.
  ![Image](https://github.com/user-attachments/assets/e0e495b4-a3f6-4b53-abc9-8f43a5318829)

- Save and run the pipeline.
  ![Image](https://github.com/user-attachments/assets/4fe7c114-058a-46f4-8a12-7e3faa2c8bee)

- Adjust the paramerts for `db` Job.
  ![Image](https://github.com/user-attachments/assets/a2fe3359-b438-40ec-9a33-434e75eef20e)

- Adjust the paramerts for `appgateway` Job.
  ![Image](https://github.com/user-attachments/assets/abd46cdc-85e8-4d74-9cab-b9541efcf840)

- Adjust the paramerts for `AKS Cluster` Job.
  ![Image](https://github.com/user-attachments/assets/3b5de562-b9ed-48f2-b447-0a93779a64e3)  

- Adjust the paramerts for `FrontDoor` Job.
  ![Image](https://github.com/user-attachments/assets/27553262-b0cd-4bd6-a380-29922d336e07)

- Adjust the `ssh key` in library for `AKS cluster`
  - `SSH public key` need to be updated
   ![Image](https://github.com/user-attachments/assets/046a1093-a9ea-4908-9b9b-85895ae46a2a)


Run the pipeline.
![Image](https://github.com/user-attachments/assets/432c3290-558c-47b1-a01f-0a9a115896a3)  

### <span style="color: yellow;"> Install SQL package on Agent VM.
- Open a PuTTY session for the virtual machine and install the required SQL package to check SQL connectivity.

  - install mssql-tools
    - sudo apt-get update
    - sudo apt-get install mssql-tools -y
  
  - Find the sqlcmd executable:
    - ls /opt/mssql-tools/bin/sqlcmd
  
  - Add the sqlcmd directory to your PATH:
    - echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
  
  - Apply the changes:
    - source ~/.bashrc

  - Verify if the PATH is Updated
    - Run this command to check if the path is correctly added:
      - echo $PATH

  ![Image](https://github.com/user-attachments/assets/b51291e1-9bbc-4b70-9c1c-2e90b5bcddba)

  - Verify the installation:
    - sqlcmd -S <server_address> -U <username> -P <password> -d <database_name>
  ![Image](https://github.com/user-attachments/assets/cdfb5be6-bd1b-4861-b36b-beeb50e12b5e)


- Convert SQL cred to base 64  
```
echo "Server=tcp:yourserver.database.windows.net,1433;Initial Catalog=yourdatabase;Persist Security Info=False;User ID=yourusername;Password=yourpassword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;" | base64 | tr -d '\n'
```
![Image](https://github.com/user-attachments/assets/17975644-1a11-410a-9c09-a137f9d10661)

- Decode base64 cred to Normal.
```sh
 echo "U2VydmVyPXRjcDpldGlja2V0ZGJzZXJ2ZXIzMDAxMjAyNS5kYXRhYmFzZS53aW5kb3dzLm5ldCwxNDMzO0luaXRpYWwgQ2F0YWxvZz1ldGlja2V0cy1kYjtQZXJzaXN0IFNlY3VyaXR5IEluZm89RmFsc2U7VXNlciBJRD1henVyZXVzZXI7UGFzc3dvcmQ9cGFzc3dvcmRAMTIzO011bHRpcGxlQWN0aXZlUmVzdWx0U2V0cz1GYWxzZTtFbmNyeXB0PVRydWU7VHJ1c3RTZXJ2ZXJDZXJ0aWZpY2F0ZT1G" | base64 -d
```

![Image](https://github.com/user-attachments/assets/b6f901f4-e941-415b-b264-6248f87ffbda)

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

![Image](https://github.com/user-attachments/assets/5c586034-bd57-49df-8bd3-6a481133bba8)

### <span style="color: yellow;"> Verify Application Accessibility.
- Try to access application gateway IP in browser and you will below error message
![Image](https://github.com/user-attachments/assets/5f26931b-b116-4747-804c-da85aa32ab80)
![Image](https://github.com/user-attachments/assets/33ae7b59-c0b6-432d-86f0-80b1fceabb9c)

## <span style="color: yellow;">  Build the second pipeline (Application).

- Build application pipeline
  ![Image](https://github.com/user-attachments/assets/6a2d7d9e-589b-410f-80c0-4c5a162b7dfc)

- Here is the updated file.

- To get the all repositories in Azure Container Registry
  - You can use the Azure CLI to check the details of repositories and images stored in a private Azure Container Registry (ACR).

    1. List all repositories in Azure Container Registry
    ```sh
    az acr repository list --name <ACR_NAME> --output table
    🔹 Replace <ACR_NAME> with the name of your Azure Container Registry.
    ```

    2. Get details of a specific repository
    ```sh
    az acr repository show --name <ACR_NAME> --repository <REPOSITORY_NAME>
    🔹 Replace <REPOSITORY_NAME> with the name of the repository inside ACR.
    ```
    3. List all image tags in a repository
    ```sh
    az acr repository show-tags --name <ACR_NAME> --repository <REPOSITORY_NAME> --output table
    🔹 This command displays the available tags for a given repository.
    ```
    4. List all manifests of an image repository
    ```sh
    az acr repository show-manifests --name <ACR_NAME> --repository <REPOSITORY_NAME> --output table
    🔹 This command provides manifest details of all images in the repository.
    ```
    5. Show details of a specific image tag
    ```sh
    az acr repository show --name <ACR_NAME> --repository <REPOSITORY_NAME> --image <IMAGE_TAG>
    🔹 Replace <IMAGE_TAG> with the tag of the image you want details for.
    ```
    6. Check the last update timestamp of an image
    ```sh
    az acr repository metadata list --name <ACR_NAME> --repository <REPOSITORY_NAME>
    🔹 This provides metadata information, including the last update timestamp.
    ```

  - Update the deployment.yaml file as below for `SQL Connection` and image name in `manifest` file.
  ![Image](https://github.com/user-attachments/assets/544e9fb5-e59c-47f2-af48-02d04950ac45)

  - Run the pipeline.
    - It will ask for permission and approve it.
    ![Image](https://github.com/user-attachments/assets/e156d14f-8f97-4d6e-bb1d-39db605854ff)

    - AKS deployment is waiting for approval
      ![Image](https://github.com/user-attachments/assets/acd32b2b-5194-4863-8c02-38f86419c6e0)

### <span style="color: yellow;"> Troubleshooting.
- I was getting an error `imagepullbackoff` and noticed that the `SQL connection` name was having a problem. To retrieve and update the string from Secret.
- Retrieve and Update Connection String from Secret
  - Since you're using a Kubernetes secret for the database connection, check the secret value:
  ```bash
  kubectl get secret db-connection-secret -o jsonpath="{.data.connection-string}" | base64 --decode
  ```
- Pipeline status
![Image](https://github.com/user-attachments/assets/8111a79c-376f-4551-9674-a6b5c553ffdb)

- Image status
![Image](https://github.com/user-attachments/assets/d684659b-7fb5-4fd0-a03c-f9a766a5c730)



- Application is accessible now fom Application Gateway.
![Image](https://github.com/user-attachments/assets/1e298a29-52e7-48b7-972b-e355b90de3ad)

- Try to create account in website.
![Image](https://github.com/user-attachments/assets/724fa414-c3d2-4d50-82dc-5ed9676eb054)

- Following are the cred to login into webpage
![Image](https://github.com/user-attachments/assets/28a139cc-9e6d-4eec-ac18-0e5214bec229)

## <span style="color: yellow;"> Application accessibility from Front Door.
![Image](https://github.com/user-attachments/assets/96667f9e-611c-4286-8576-6f386a815670)
![Image](https://github.com/user-attachments/assets/40bee6c7-2f28-43f1-a214-022d43fba9ea)

Congratulations :-) the application is working and accessible.
![Image](https://github.com/user-attachments/assets/5a9efd1f-1584-4b6a-bb13-4756c44ea252)

Pipenline Status
![Image](https://github.com/user-attachments/assets/4e1fb7d3-6aad-489e-9f82-ab015e539b0f)

## <span style="color: yellow;"> Pipeline for Cleanup Infra Setup.</span>
- Following are the sequence to delete the setup using pipeline.
  - FrontDoor
  - AKS Cluster
  - Application Gateway
  - Azure Container Registry
  - SQL Database
  - Agent VM
  - VNet
  
- Here is the 👉[Updated pipeline](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/11_Real-Time-DevOps-Project_CI-CD_Terraform_ACR_Storage_WebApp_SQL/Pipeline/Destroy%20Infra.md)👈 

![Image](https://github.com/user-attachments/assets/701d8225-1977-4b98-9a8c-500c5b26b956)

## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete `ssh_key`, `Vault` and `Storage account`.

- Run the terraform command.
  ```bash
  Terraform destroy --auto-approve
  ```

- I was getting the below error message while deleting the setup. It is getting failed in deleting `ResourceGroup`
![Image](https://github.com/user-attachments/assets/81ae4575-01fb-47f2-8f4b-8207862394dc)

  - Rerun the destroy command again and it will delete `ResourceGroup` as well.
  ![Image](https://github.com/user-attachments/assets/86309505-ce7b-47d1-9459-4e4e9b3f194d)

## <span style="color: Yellow;"> Conclusion

This document outlines the comprehensive setup of a secure and efficient CICD pipeline for deploying a web application on a private AKS cluster, integrated with various Azure services. By leveraging Terraform for infrastructure as code, Azure DevOps for pipeline management, and Azure Front Door for global load balancing, the solution ensures high availability, security, and optimal performance for the application.

For detailed steps and configurations, refer to the provided Terraform scripts and Azure DevOps pipeline definitions.


__Ref Link:__


- [Azure FrontDoor- YouTube Link](https://www.youtube.com/watch?v=KplNosFAxXU)
  - [Rest of Infra Setup- YouTube Link](https://www.youtube.com/watch?v=PDBoprlJfUw)
- [Standard and Basic SKU](https://learn.microsoft.com/en-us/answers/questions/1349124/azure-cannot-change-the-static-ip-address)
- [Terraform code for azurerm_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip)
- [Terraform code for azurerm_kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/2.17.0/docs/resources/kubernetes_cluster)
- [AKS cluster_node_pool](https://registry.terraform.io/providers/hashicorp/azurerm/2.48.0/docs/resources/kubernetes_cluster_node_pool)
- [Kubernetes versions details ](https://learn.microsoft.com/en-us/azure/aks/supported-kubernetes-versions?tabs=azure-cli#supported-version-list)
- [Billing FAQs](https://learn.microsoft.com/en-us/azure/devops/organizations/billing/billing-faq?view=azure-devops&viewFallbackFrom=vsts&tabs=new-nav)
