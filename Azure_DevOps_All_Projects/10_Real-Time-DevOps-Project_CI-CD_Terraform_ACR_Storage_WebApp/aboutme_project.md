

## Azure DevOps + Terraform + Azure Container Web App CICD Process

This document describes the process of setting up a CI/CD pipeline using Azure DevOps, Terraform, and Azure Container Web App for deploying a Python-based web application. The deployment is automated and can be triggered with a single click.

### Key Points

1. **Architecture Overview**:
   - The architecture includes components such as Azure Repos, Azure Storage Account, Build Pipeline, and Release Pipeline.
   - Terraform is used for infrastructure as code, and the state file is stored securely in Azure Storage Account.

2. **Build Pipeline**:
   - The build pipeline includes tasks to build and push a Docker image to Azure Container Registry.
   - Terraform configuration files are published as pipeline artifacts for use in the release pipeline.

3. **Release Pipeline**:
   - The release pipeline is linked to the artifacts published by the build pipeline.
   - It includes stages for deploying resources to Dev and QA environments using Terraform.
   - Auto-scaling and alert configurations are set up for the web app.

4. **Terraform Configuration**:
   - Separate files for providers, variables, and main configuration.
   - Variables are stored securely and referenced in the configuration files.
   - The configuration includes creating an Azure App Service Plan, Web App, Auto Scale settings, and Alerts.

5. **Service Connections**:
   - Azure DevOps service connections are created for authentication with Azure and Docker Registry.

### Detailed Steps

1. **Setting Up the Architecture**:
   - **Azure Repos**: Store the source code and Terraform configuration files.
   - **Azure Storage Account**: Store the Terraform state file securely.
   - **Build Pipeline**: Configure tasks to build and push Docker images.
   - **Release Pipeline**: Configure tasks to deploy resources using Terraform.

2. **Configuring the Build Pipeline**:
   - **Build and Push Docker Image**: Use Docker to build the application image and push it to Azure Container Registry.
   - **Publish Terraform Files**: Publish Terraform configuration files as pipeline artifacts.

3. **Configuring the Release Pipeline**:
   - **Initialize Terraform**: Initialize the Terraform working directory and download necessary plugins.
   - **Apply Terraform Configuration**: Apply the Terraform configuration to create resources in Azure.
   - **Deploy Web App**: Deploy the Docker image to Azure Web App.
   - **Configure Auto-Scaling and Alerts**: Set up auto-scaling rules and alert notifications.

4. **Terraform Configuration Files**:
   - **Provider Configuration**: Define the Azure provider and authentication details.
   - **Variable Definitions**: Define variables for resource names, locations, and other configurations.
   - **Main Configuration**: Define the resources to be created, including App Service Plan, Web App, Auto Scale settings, and Alerts.

5. **Creating Service Connections**:
   - **Azure Service Connection**: Authenticate with Azure for deploying resources.
   - **Docker Registry Service Connection**: Authenticate with Azure Container Registry for pushing Docker images.

### Advantages

- **Automation**: The entire deployment process is automated, reducing manual intervention and errors.
- **Scalability**: Auto-scaling ensures that the application can handle varying loads efficiently.
- **Security**: Storing Terraform state files in Azure Storage Account ensures the security and integrity of the infrastructure state.
- **Flexibility**: The use of variables and separate configuration files allows for easy customization and scalability of the infrastructure.

### Conclusion

This project demonstrates a robust CI/CD pipeline setup using Azure DevOps, Terraform, and Azure Container Web App. By automating the deployment process, it ensures efficient, scalable, and secure deployment of a Python-based web application. The use of Terraform for infrastructure as code provides flexibility and ease of management, making it a valuable approach for modern cloud-based applications.

![Image](https://github.com/user-attachments/assets/d2802609-0e91-4a3a-96e4-584b8517b502)


add the agent- 
![Image](https://github.com/user-attachments/assets/afe19e14-fd2e-4687-b743-2d392d930cb8)
![Image](https://github.com/user-attachments/assets/2f131727-4638-4c0c-82c9-36016c67c4e6)
![Image](https://github.com/user-attachments/assets/50eabe5e-9d38-4145-951a-0ec84ac7e726)

# Createe service connection:
![Image](https://github.com/user-attachments/assets/5ce7e3b4-ecf4-45ce-8da0-a2209df2fa2a)
![Image](https://github.com/user-attachments/assets/a2d2132f-b9a6-49ec-8496-4e43e73bc3a7)
![Image](https://github.com/user-attachments/assets/babe6a89-c55e-40a3-a952-c0877937fa3d)
![Image](https://github.com/user-attachments/assets/e477ddd3-18fa-4119-b06b-36b05ddb0476)


- Azure Container registory
  
![Image](https://github.com/user-attachments/assets/57e4b218-b0d8-47b0-8540-d672aede59ff)
![Image](https://github.com/user-attachments/assets/4f014723-45b6-487c-acad-a1cda3dc0a6f)


# update the variables.
- for ACR
![Image](https://github.com/user-attachments/assets/127f0101-8fea-4470-9bbb-99cab70653c6)

- Create  a pipeline.

![Image](https://github.com/user-attachments/assets/d0681a85-a214-42f8-96b9-ff0e92a842d7)
![Image](https://github.com/user-attachments/assets/d221eabb-ccd3-4348-9268-aed2741578f5)
![Image](https://github.com/user-attachments/assets/dfdaea87-025d-4462-b3f3-348815336dd9)


- Here is the updated pipeline
**Note**: you have to adjust connnection name, and acr name.
![Image](https://github.com/user-attachments/assets/bbe1765b-44d2-4531-9e6e-3056cee7de40)


- Library
![Image](https://github.com/user-attachments/assets/083bc64e-b714-4cac-8d8d-6a9b437ad96f)


- add pipeline in dev-var variable Group.
![Image](https://github.com/user-attachments/assets/1b5189da-baa7-48e6-9928-c70faf5c92e2)


# build Release pipeline.
![Image](https://github.com/user-attachments/assets/abd4d3c7-9d70-408f-b1e9-e17c82f010c8)

- Empty pipeline
  - add artifact.
 ![Image](https://github.com/user-attachments/assets/59464714-56fc-4189-a6c5-e9d62ba80ba6)
![Image](https://github.com/user-attachments/assets/f534845d-53f5-41ee-ba00-064e88f7b6ff)


  - add stages (Extract files, Terraform and Apps)
   ![Image](https://github.com/user-attachments/assets/8685a267-6643-4a47-b7f3-d2d5cfc67768)
   ![Image](https://github.com/user-attachments/assets/48d36ed2-5e89-44c9-a6f2-e43a84480f86)

  
  - **Add stage**- Install Terraform latest
      ![Image](https://github.com/user-attachments/assets/e0b3af19-1bc4-4c98-9ebf-5bd7a6603020)

  - **Add stage**- Extract Files
      ```sh
      Extract files

      Archive file patterns *
      $(System.DefaultWorkingDirectory)/**/*.zip

      Destination folder *
      $(agent.builddirectory)
      ```
      ![Image](https://github.com/user-attachments/assets/40c2a353-e95e-4d3a-8ecd-7d1a8e532a7a)
  - **Add stage**- Terraform Init
      ```sh
      # Configuration Directory
      $(agent.builddirectory)/Terraform
      ```
![Image](https://github.com/user-attachments/assets/7729c368-6ef3-4079-ba5a-b0c47c262fcd)
![Image](https://github.com/user-attachments/assets/7e52318b-cdbb-4d53-8841-2e76d77d1980)


  - **Add stage**- Terraform fmt
      ```sh
      # Configuration Directory
      $(agent.builddirectory)/Terraform
      ```
      ![Image](https://github.com/user-attachments/assets/ade4a2c3-5324-4319-ba6e-17b5cf8b0446)

  - **Add stage**- Terraform validate
      ```sh
      # Configuration Directory
      $(agent.builddirectory)/Terraform
      ```
      ![Image](https://github.com/user-attachments/assets/246b9e8f-6de4-494a-bbba-c45022a54dff)

  - **Add stage**- Terraform Plan  
      ```sh
      # Configuration Directory
      $(agent.builddirectory)/Terraform
      ```
      ![Image](https://github.com/user-attachments/assets/6d9f6edd-8c8c-40c1-b44d-6e3917d2a195)

  - **Add stage**- Terraform Apply
      ```sh
      # Configuration Directory
      $(agent.builddirectory)/Terraform
      ```
      ![Image](https://github.com/user-attachments/assets/3ba84fd1-ce43-4d4b-a094-fab39ce69f48)

  - **Add stage**- Application Deployment
      ```sh
      Display name: Azure App Service Deploy: $(TF_VAR_WEBAPPNAME)
      App Service type:Web App for Containers (Linux)
      App Service name: $(TF_VAR_WEBAPPNAME)
      Registry or Namespace: $(TF_VAR_DOCKER_REGISTRY_SERVER_URL)
      Image: pythonappdocker (it can be found from ACR in Repositories name)
      tags: $(Build.BuildId)
      Startup command : python main.py
      ```
      ![Image](https://github.com/user-attachments/assets/b0fd3a7f-0fd3-452b-bce0-1ec427f8cb1d)

  - **Add stage**- Application Restart
      ![Image](https://github.com/user-attachments/assets/058c40c1-d3f1-4b48-8c69-9ce4a7bf0e72)

save the pipeline
Now, we will add varialbe in pipeline.

![Image](https://github.com/user-attachments/assets/fbd84d93-45dc-4e88-a089-263a46c90fc5)
![Image](https://github.com/user-attachments/assets/b658774f-6c31-442f-92f0-419e9c04b971)



- run the release pipeline.

- Pipeline execure successfully.
![Image](https://github.com/user-attachments/assets/e6dc4313-ea0b-4753-8f66-ec90376cbbe5)

- Application is accessible now.
![Image](https://github.com/user-attachments/assets/86be47cd-d1fb-4144-abf5-eeec6d0d3f10)


# add stage for QA

clone the Dev Pipeline and adjust the variable as below.

```sh
#Configuration directory
$(Build.SourcesDirectory)/Terraform
```
![Image](https://github.com/user-attachments/assets/f1c4c66b-022b-4621-a547-710050a9bdcc)


![Image](https://github.com/user-attachments/assets/26d884b8-68c5-44a2-ac15-57b34e09e5a8)

![Image](https://github.com/user-attachments/assets/9439474d-85de-45ca-9c1d-13b8c0ec0ae3)

Pipeline State:
![Image](https://github.com/user-attachments/assets/80bb8486-64aa-4495-9163-8c735e9978b8)

# add stage for Destroy both enviornment.
clone the Dev and QA stage for destroy and modify the apply to Destroy. Rest of things will remain same.


![Image](https://github.com/user-attachments/assets/85243f0c-45a4-4975-ab87-8b486e0c9ee7)

Pipeline view.
![Image](https://github.com/user-attachments/assets/a8b2070c-6956-4493-9687-5c8af34aaa7b)
![Image](https://github.com/user-attachments/assets/b34c1588-9cfd-41a7-803c-17f3292f6fa8)

- add apporval in stage if you wish to.
![Image](https://github.com/user-attachments/assets/291ecfde-f3d5-47e5-9017-054ed8ba8261)

![Image](https://github.com/user-attachments/assets/054d6dfd-d23f-4cd0-b3a1-652e1b2630a0)


```sh
Extract files

Archive file patterns *
$(System.DefaultWorkingDirectory)/**/*.zip

Destination folder *
$(agent.builddirectory)


# Terraform init & Plan, Apply
$(agent.builddirectory)/Terraform
```


1. List All Storage Accounts; To list all storage accounts in your Azure subscription:

```bash
az storage account list --output table
```
2. List All Containers in a Storage Account
To list all containers in a specific storage account:
```bash
az storage container list --account-name <STORAGE_ACCOUNT_NAME> --output table
```
Replace <STORAGE_ACCOUNT_NAME> with the name of your storage account.



- https://www.youtube.com/watch?v=1XfazFLPfQQ&list=PLJcpyd04zn7p_nI0hoYRcqSqVS_9_eLaR&index=181

- https://learn.microsoft.com/en-us/azure/devops/pipelines/release/variables?view=azure-devops&tabs=batch

- https://learn.microsoft.com/en-us/azure/devops/pipelines/build/variables?view=azure-devops&tabs=yaml
************
