

# <span style="color: Yellow;"> One-Click Azure DevOps CI/CD Pipeline for Azure Container Web Apps with Terraform Integration

This document describes the process of setting up a CI/CD pipeline using Azure DevOps, Terraform, and Azure Container Web App for deploying a Python-based web application. The deployment is automated and can be triggered with a single click.

## <span style="color: Yellow;"> Prerequisites </span>

Before diving into this project, here are some skills and tools you should be familiar with:

Need to create a PAT access Token-

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/10_Real-Time-DevOps-Project_CI-CD_Terraform_ACR_Storage_WebApp)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
    - Update ```terraform.tfvars```
     
- [x] [App Repo](https://github.com/mrbalraj007/python-app-docker.git)

- [x] __Azure Account__: You’ll need an Azure account to create resources like virtual Machine, AKS cluster, and manage pipelines.
- [x] __Terraform Knowledge__: Familiarity with Terraform to provision, manage, and clean up infrastructure.
- [x] __GitHub__: Experience with GitHub for version control and managing repositories.
- [x] __Command-Line Tools__: Basic comfort with using the command line for managing infrastructure and services.
- [x] __Basic CI/CD Knowledge__: Some understanding of Continuous Integration and Deployment is recommended.
- [x] __Linux VM__: Docker must be installed on a Linux virtual machine to run containers.


##  <span style="color: Yellow;"> Key Points

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


## <span style="color: Yellow;">Setting Up the Infrastructure </span>

I have created a Terraform code to set up the entire infrastructure, including the installation of required applications, tools, and storage automatically created.

- &rArr; <span style="color: brown;">Virtual machines will be created named as ```"devopsdemovm"```

- &rArr;<span style="color: brown;"> Docker Install
- &rArr;<span style="color: brown;"> Azure Cli Install
- &rArr;<span style="color: brown;"> Storage Setup
- &rArr;<span style="color: brown;"> ACR Setup

### <span style="color: Yellow;"> Virtual Machine creation

First, we'll create the necessary virtual machines using ```terraform``` code. 

Below is a terraform Code:

Once you [clone repo](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/10_Real-Time-DevOps-Project_CI-CD_Terraform_ACR_Storage_WebApp)</span> and run the terraform command.
```bash
$ ls -l
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
dar--l          26/12/24   7:16 PM                pipeline
dar--l          23/12/24   3:38 PM                scripts
-a---l          25/12/24   2:31 PM            600 .gitignore
-a---l          26/12/24   9:29 PM           6571 EC2.tf
-a---l          26/12/24   9:29 PM            892 main.tf
-a---l          26/12/24   9:29 PM            567 output.tf
-a---l          26/12/24   9:29 PM            269 provider.tf
-a---l          26/12/24   9:30 PM            223 terraform.tfvars
-a---l          26/12/24   9:30 PM            615 variable.tf
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
-------
![Image](https://github.com/user-attachments/assets/d2802609-0e91-4a3a-96e4-584b8517b502)

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

### <span style="color: cyan;"> Verify the Installation 

- [x] <span style="color: brown;"> Docker version
```bash
ubuntu@ip-172-31-95-197:~$ docker --version
Docker version 24.0.7, build 24.0.7-0ubuntu4.1


docker ps -a
ubuntu@ip-172-31-94-25:~$ docker ps
```
- [x] <span style="color: brown;"> kubectl version
```bash
ubuntu@ip-172-31-89-97:~$ kubectl version
Client Version: v1.31.1
Kustomize Version: v5.4.2
```
- [x] <span style="color: brown;"> Azure cli version
```bash
azureuser@devopsdemovm:~$ az version
{
  "azure-cli": "2.67.0",
  "azure-cli-core": "2.67.0",
  "azure-cli-telemetry": "1.1.0",
  "extensions": {}
}
```
##  <span style="color: Yellow;"> Detailed Steps

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


### <span style="color: Yellow;"> Step-by-Step Process:</span>

- #### <span style="color: cyan;"> Add the Agent: 
![Image](https://github.com/user-attachments/assets/afe19e14-fd2e-4687-b743-2d392d930cb8)
![Image](https://github.com/user-attachments/assets/2f131727-4638-4c0c-82c9-36016c67c4e6)
![Image](https://github.com/user-attachments/assets/50eabe5e-9d38-4145-951a-0ec84ac7e726)

- #### <span style="color: cyan;">  Create Service Connection:
  - For Azure
![Image](https://github.com/user-attachments/assets/5ce7e3b4-ecf4-45ce-8da0-a2209df2fa2a)
![Image](https://github.com/user-attachments/assets/a2d2132f-b9a6-49ec-8496-4e43e73bc3a7)
![Image](https://github.com/user-attachments/assets/babe6a89-c55e-40a3-a952-c0877937fa3d)
![Image](https://github.com/user-attachments/assets/e477ddd3-18fa-4119-b06b-36b05ddb0476)


  - Azure Container registory

   ![Image](https://github.com/user-attachments/assets/57e4b218-b0d8-47b0-8540-d672aede59ff)
   ![Image](https://github.com/user-attachments/assets/4f014723-45b6-487c-acad-a1cda3dc0a6f)


- #### <span style="color: cyan;">  Update variables for pipeline.
  - for ACR
   ![Image](https://github.com/user-attachments/assets/127f0101-8fea-4470-9bbb-99cab70653c6)

  - Create  a pipeline.

   ![Image](https://github.com/user-attachments/assets/d0681a85-a214-42f8-96b9-ff0e92a842d7)
   ![Image](https://github.com/user-attachments/assets/d221eabb-ccd3-4348-9268-aed2741578f5)
   ![Image](https://github.com/user-attachments/assets/dfdaea87-025d-4462-b3f3-348815336dd9)


- Here is the 👉[updated pipeline](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/10_Real-Time-DevOps-Project_CI-CD_Terraform_ACR_Storage_WebApp/Pipeline/CI_only.md)👈<br>
**Note**: you have to adjust connnection name, and acr name.
![Image](https://github.com/user-attachments/assets/bbe1765b-44d2-4531-9e6e-3056cee7de40)


- Verify variable group in Library
![Image](https://github.com/user-attachments/assets/083bc64e-b714-4cac-8d8d-6a9b437ad96f)


- add pipeline in `dev-var` variable Group.
![Image](https://github.com/user-attachments/assets/1b5189da-baa7-48e6-9928-c70faf5c92e2)


- #### <span style="color: cyan;"> Build Release pipeline.
![Image](https://github.com/user-attachments/assets/abd4d3c7-9d70-408f-b1e9-e17c82f010c8)

  - Create Empty pipeline
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
  - Now, we will add varialbe in pipeline.

   ![Image](https://github.com/user-attachments/assets/fbd84d93-45dc-4e88-a089-263a46c90fc5)
   ![Image](https://github.com/user-attachments/assets/b658774f-6c31-442f-92f0-419e9c04b971)



- run the release pipeline.

- Pipeline execute successfully.
![Image](https://github.com/user-attachments/assets/e6dc4313-ea0b-4753-8f66-ec90376cbbe5)

- Application is accessible now.
![Image](https://github.com/user-attachments/assets/86be47cd-d1fb-4144-abf5-eeec6d0d3f10)


- #### <span style="color: cyan;"> Add stage for QA

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

- #### <span style="color: cyan;"> Add stage for Destroy both enviornment.
clone the Dev and QA stage for destroy and modify the apply to Destroy. Rest of things will remain same.


![Image](https://github.com/user-attachments/assets/85243f0c-45a4-4975-ab87-8b486e0c9ee7)

Pipeline view.
![Image](https://github.com/user-attachments/assets/a8b2070c-6956-4493-9687-5c8af34aaa7b)
![Image](https://github.com/user-attachments/assets/b34c1588-9cfd-41a7-803c-17f3292f6fa8)

- add apporval in stage if you wish to.
![Image](https://github.com/user-attachments/assets/291ecfde-f3d5-47e5-9017-054ed8ba8261)

![Image](https://github.com/user-attachments/assets/054d6dfd-d23f-4cd0-b3a1-652e1b2630a0)


<!-- ```sh
Extract files

Archive file patterns *
$(System.DefaultWorkingDirectory)/**/*.zip

Destination folder *
$(agent.builddirectory)


# Terraform init & Plan, Apply
$(agent.builddirectory)/Terraform
``` -->


###  <span style="color: Yellow;"> Advantages

- **Automation**: The entire deployment process is automated, reducing manual intervention and errors.
- **Scalability**: Auto-scaling ensures that the application can handle varying loads efficiently.
- **Security**: Storing Terraform state files in Azure Storage Account ensures the security and integrity of the infrastructure state.
- **Flexibility**: The use of variables and separate configuration files allows for easy customization and scalability of the infrastructure.

###  <span style="color: Yellow;"> Conclusion

This project demonstrates a robust CI/CD pipeline setup using Azure DevOps, Terraform, and Azure Container Web App. By automating the deployment process, it ensures efficient, scalable, and secure deployment of a Python-based web application. The use of Terraform for infrastructure as code provides flexibility and ease of management, making it a valuable approach for modern cloud-based applications.


__Ref Link:__

- [Youtube Link](https://www.youtube.com/watch?v=1XfazFLPfQQ&list=PLJcpyd04zn7p_nI0hoYRcqSqVS_9_eLaR&index=181)

- [Azure-Devops_Pipeline_Variable-01](https://learn.microsoft.com/en-us/azure/devops/pipelines/release/variables?view=azure-devops&tabs=batch)

- [Azure-Devops_Pipeline_Variable-02](https://learn.microsoft.com/en-us/azure/devops/pipelines/build/variables?view=azure-devops&tabs=yaml)
************
