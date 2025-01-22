

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


![alt text](/All_ScreenShot/image.png)

add the agent- 
![alt text](/All_ScreenShot/image-1.png)
![alt text](/All_ScreenShot/image-2.png)
![alt text](/All_ScreenShot/image-3.png)

# Createe service connection:
![alt text](/All_ScreenShot/image-4.png)
![alt text](/All_ScreenShot/image-5.png)
![alt text](/All_ScreenShot/image-6.png)
![alt text](/All_ScreenShot/image-7.png)

- Azure Container registory
  ![alt text](/All_ScreenShot/image-8.png)
  ![alt text](/All_ScreenShot/image-9.png)

# update the variables.
- for ACR
![alt text](/All_ScreenShot/image-10.png)

- Create  a pipeline.

![alt text](/All_ScreenShot/image-12.png)
![alt text](/All_ScreenShot/image-13.png)
![alt text](/All_ScreenShot/image-14.png)

- Here is the updated pipeline
**Note**: you have to adjust connnection name, and acr name.
![alt text](/All_ScreenShot/image-15.png)


- Library
![alt text](/All_ScreenShot/image-11.png)

- add pipeline in dev-var variable Group.
![alt text](/All_ScreenShot/image-16.png)


# build Release pipeline.
![alt text](/All_ScreenShot/image-17.png)

- Empty pipeline
  - add artifact.
  ![alt text](/All_ScreenShot/image-18.png)
  ![alt text](/All_ScreenShot/image-19.png)

  - add stages (Extract files, Terraform and Apps)
   ![alt text](/All_ScreenShot/image-21.png)
   ![alt text](/All_ScreenShot/image-20.png)
  
  - **Add stage**- Install Terraform latest
      ![alt text](/All_ScreenShot/image-22.png)

  - **Add stage**- Extract Files
      ```sh
      Extract files

      Archive file patterns *
      $(System.DefaultWorkingDirectory)/**/*.zip

      Destination folder *
      $(agent.builddirectory)
      ```
      ![alt text](/All_ScreenShot/image-23.png)
  - **Add stage**- Terraform Init
      ```sh
      # Configuration Directory
      $(agent.builddirectory)/Terraform
      ```
   ![alt text](/All_ScreenShot/image-24.png)
   ![alt text](/All_ScreenShot/image-25.png)

  - **Add stage**- Terraform fmt
      ```sh
      # Configuration Directory
      $(agent.builddirectory)/Terraform
      ```
      ![alt text](/All_ScreenShot/image-26.png)

  - **Add stage**- Terraform validate
      ```sh
      # Configuration Directory
      $(agent.builddirectory)/Terraform
      ```
      ![alt text](/All_ScreenShot/image-27.png)

  - **Add stage**- Terraform Plan  
      ```sh
      # Configuration Directory
      $(agent.builddirectory)/Terraform
      ```
      ![alt text](/All_ScreenShot/image-28.png)

  - **Add stage**- Terraform Apply
      ```sh
      # Configuration Directory
      $(agent.builddirectory)/Terraform
      ```
      ![alt text](/All_ScreenShot/image-29.png)

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
      ![alt text](/All_ScreenShot/image-30.png)

  - **Add stage**- Application Restart
      ![alt text](/All_ScreenShot/image-31.png)

save the pipeline
Now, we will add varialbe in pipeline.

![alt text](/All_ScreenShot/image-32.png)
![alt text](/All_ScreenShot/image-33.png)


- run the release pipeline.

- Pipeline execure successfully.
![alt text](/All_ScreenShot/image-34.png)

- Application is accessible now.
![alt text](/All_ScreenShot/image-35.png)


# add stage for QA

clone the Dev Pipeline and adjust the variable as below.

```sh
#Configuration directory
$(Build.SourcesDirectory)/Terraform
```
![alt text](/All_ScreenShot/image-41.png)


![alt text](/All_ScreenShot/image-36.png)

![alt text](/All_ScreenShot/image-37.png)

Pipeline State:
![alt text](/All_ScreenShot/image-42.png)

# add stage for Destroy both enviornment.
clone the Dev and QA stage for destroy and modify the apply to Destroy. Rest of things will remain same.


![alt text](/All_ScreenShot/image-38.png)

Pipeline view.
![alt text](/All_ScreenShot/image-39.png)
![alt text](/All_ScreenShot/image-44.png)

- add apporval in stage if you wish to.
![alt text](/All_ScreenShot/image-40.png)

![alt text](/All_ScreenShot/image-43.png)


```sh
Extract files

Archive file patterns *
$(System.DefaultWorkingDirectory)/**/*.zip

Destination folder *
$(agent.builddirectory)


# Terraform init & Plan, Apply
$(agent.builddirectory)/Terraform
```

```sh
1. List All Storage Accounts
To list all storage accounts in your Azure subscription:

bash
Copy
Edit
az storage account list --output table
2. List All Containers in a Storage Account
To list all containers in a specific storage account:

bash
Copy
Edit
az storage container list --account-name <STORAGE_ACCOUNT_NAME> --output table
Replace <STORAGE_ACCOUNT_NAME> with the name of your storage account.
```


# https://www.youtube.com/watch?v=1XfazFLPfQQ&list=PLJcpyd04zn7p_nI0hoYRcqSqVS_9_eLaR&index=181

https://learn.microsoft.com/en-us/azure/devops/pipelines/release/variables?view=azure-devops&tabs=batch

https://learn.microsoft.com/en-us/azure/devops/pipelines/build/variables?view=azure-devops&tabs=yaml
