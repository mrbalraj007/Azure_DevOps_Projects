# Implementing CI/CD with Azure DevOps: Azure Artifacts and Release Pipelines

![Image](https://github.com/user-attachments/assets/79c7176e-ef46-47bd-8eca-6595e87aa72a)

## <span style="color: Yellow;"> Overview

This document provides a step-by-step guide on setting up a CI/CD pipeline using Azure Artifacts and Azure DevOps. The project involves deploying a sample Nike landing page using Tailwind CSS.

## <span style="color: Yellow;"> Key Points

1. **Introduction to Azure Artifacts**:
   - Azure Artifacts is a central repository for storing and consuming packages.
   - Benefits include maintaining history, auditing, and consuming packages across multiple pipelines and projects.

2. **Setting Up the Project**:
   - Create a new Azure DevOps project.
   - Import the sample project repository from GitHub.

3. **Creating Azure Resources**:
   - Create an Azure Web App service.
   - Configure application settings to refresh the cache after deployments.

4. **CI Pipeline Configuration**:
   - Create a CI pipeline in YAML.
   - Install dependencies and build the project using Tailwind CSS.
   - Publish the package to Azure Artifacts.

5. **Managing Permissions**:
   - Ensure the build service account has contributor access to the Azure Artifacts feed.

6. **Creating a Release Pipeline**:
   - Set up a release pipeline to deploy the package from Azure Artifacts to the Azure Web App.
   - Enable triggers for package promotion.

7. **Deployment and Verification**:
   - Deploy the application and verify the deployment by accessing the web app.
   - Use Azure portal tools for troubleshooting and log analysis.

## <span style="color: Yellow;"> Tools and Technologies Used

- **Azure DevOps**: For CI/CD pipeline setup and project management.
- **Azure Artifacts**: For package management and storage.
- **Azure Web App**: For hosting the deployed application.
- **Tailwind CSS**: For building the project.
- **GitHub**: For source code repository.
- **Kudu Console**: For interacting with the web app's underlying host operating system.


## <span style="color: Yellow;"> Prerequisites </span>

Before diving into this project, here are some skills and tools you should be familiar with:

Need to create a PAT access Token-

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/07.1_Real-Time-DevOps-Project_CI-CD_WebApp_ArtiFact_Selfhosted_Agent/Terraform_Code)<br>

  __Note__: Replace resource names and variables as per your requirement in terraform code
    - Update ```terraform.tfvars```.
 
- [x] [App Repo (Nike App)](https://github.com/piyushsachdeva/nike_landing_page.git)

- [x] __Azure Account__: You’ll need an Azure account to create resources like virtual Machine, AKS cluster, and manage pipelines.
- [x] __Terraform Knowledge__: Familiarity with Terraform to provision, manage, and clean up infrastructure.
- [x] __GitHub__: Experience with GitHub for version control and managing repositories.
- [x] __Command-Line Tools__: Basic comfort with using the command line for managing infrastructure and services.
- [x] __Basic CI/CD Knowledge__: Some understanding of Continuous Integration and Deployment is recommended.
- [x] __Linux VM__: Docker must be installed on a Linux virtual machine to run containers.

## <span style="color: Yellow;">Setting Up Infrastructure </span>

I have created a Terraform code to set up the entire infrastructure, including the installation of required applications and tools.

- &rArr; <span style="color: brown;">Virtual machines will be created named as ```"devopsdemovm"```

- &rArr;<span style="color: brown;"> Docker Install
- &rArr;<span style="color: brown;"> Azure Cli Install

### <span style="color: Yellow;"> Virtual Machine creation

First, we'll create the necessary virtual machines using ```terraform``` code. 

Below is a terraform Code:

Once you [clone repo](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/07.1_Real-Time-DevOps-Project_CI-CD_WebApp_ArtiFact_Selfhosted_Agent/Terraform_Code)</span> and run the terraform command.
```bash
$ ls -l
-rw-r--r-- 1 bsingh 1049089   261 Feb 10 11:10 azure_artifact.tf 
-rw-r--r-- 1 bsingh 1049089   437 Feb 10 10:48 DevOps_UI.tf      
-rw-r--r-- 1 bsingh 1049089   920 Feb 10 10:52 output.tf
-rw-r--r-- 1 bsingh 1049089   528 Jan  8 15:25 provider.tf       
drwxr-xr-x 1 bsingh 1049089     0 Feb  7 18:08 scripts/
-rw-r--r-- 1 bsingh 1049089  6261 Feb 10 09:45 Selfthost-Agent.tf
-rw-r--r-- 1 bsingh 1049089   274 Jan  8 13:28 ssh_key.tf
-rw-r--r-- 1 bsingh 1049089  1871 Feb 10 11:06 terraform.tfvars
-rw-r--r-- 1 bsingh 1049089  2847 Feb 10 10:52 variable.tf
-rw-r--r-- 1 bsingh 1049089   682 Feb 10 09:34 web-app.tf
```

You need to run the following terraform command.

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply 
# Optional <terraform apply --auto-approve>
```
- Terraform Output:
![Image](https://github.com/user-attachments/assets/e09d3a43-8848-494b-afc8-ee7948c2264c)

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

### <span style="color: cyan;"> Verify software Installation 

- [x] <span style="color: brown;"> Docker version
```bash
azureuser@devopsdemovm:~$  docker --version
Docker version 24.0.7, build 24.0.7-0ubuntu4.1

docker ps -a
azureuser@devopsdemovm:~$ docker ps

azureuser@devopsdemovm:~$ docker image ls
REPOSITORY                                       TAG       IMAGE ID       CREATED       SIZE
mc1arke/sonarqube-with-community-branch-plugin   latest    307499b84ff2   13 days ago   1.13GB

azureuser@devopsdemovm:~$ docker container ls
CONTAINER ID   IMAGE                                            COMMAND                  CREATED          STATUS          PORTS                                       NAMES
973939f2cdc7   mc1arke/sonarqube-with-community-branch-plugin   "/opt/sonarqube/dock…"   41 minutes ago   Up 41 minutes   0.0.0.0:9000->9000/tcp, :::9000->9000/tcp   sonar
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
- [x] <span style="color: brown;"> Java Version
```sh
azureuser@devopsdemovm:~$ java --version
openjdk 17.0.13 2024-10-15
OpenJDK Runtime Environment (build 17.0.13+11-Ubuntu-2ubuntu122.04)
OpenJDK 64-Bit Server VM (build 17.0.13+11-Ubuntu-2ubuntu122.04, mixed mode, sharing)
```
- [x] <span style="color: brown;"> Trivy Version
```sh
azureuser@devopsdemovm:~$ trivy --version
Version: 0.58.1
```
- [x] <span style="color: brown;"> Maven Version
```sh
azureuser@devopsdemovm:~$ mvn -version
Apache Maven 3.6.3
Maven home: /usr/share/maven
Java version: 17.0.13, vendor: Ubuntu, runtime: /usr/lib/jvm/java-17-openjdk-amd64
Default locale: en, platform encoding: UTF-8
OS name: "linux", version: "6.5.0-1025-azure", arch: "amd64", family: "unix"
azureuser@devopsdemovm:~$
```

## <span style="color: Yellow;"> Step-by-Step Process:</span>

### <span style="color: cyan;"> Verify application accessiblity

- Configure Web App

  - I tried to open in browser and got below page it is because of By default azure cache is enabled and we have to disable it.
  - Go to Web App and add the following settings.

  ```bash
    Name: WEBSITE_DYNAMIC_CACHE
    Value: 0

    Name: WEBSITE_ENABLE_SYNC_UPDATE_SITE
    Value: never

    Name: WEBSITE_LOCAL_CACHE_OPTION
    Value: never

  ```
  ![Image](https://github.com/user-attachments/assets/22667efa-f191-4c86-b270-b1f185db4805)

  - Restart the webapp application.

  - Verify default Application accessible or not.
  ![Image](https://github.com/user-attachments/assets/e5d228ae-8775-4cdb-970f-bba5a633ca49)

  - Default App is accessible.
  ![Image](https://github.com/user-attachments/assets/13ce9845-bae3-4bc7-9cf9-cd28d271e4ee)

### <span style="color: cyan;"> Verify Project Status
- Select the Organization> verify project is created or not.
  ![Image](https://github.com/user-attachments/assets/5088975f-190e-4ee6-b12c-75257b1bd298)

### <span style="color: cyan;"> Verify Repo Status
- select the project and verify repo is imported or not.
![Image](https://github.com/user-attachments/assets/02cbfdf8-0b04-4c17-8e51-4d8e98514958)

### <span style="color: cyan;"> Configure Service Connection

- First create [Service Connection](https://www.youtube.com/watch?v=pSmKNbN_Y4s) in Azure Devops.
- Once you create a connection then note it down the connection Name, because that name would be used in pipeline. 
- On agent machine, make sure login with azure login and connection is active, if not then login with following.
  ```sh
  az login --use-device-code
  ```
- Need to Create a service Connection in pipeline first.
     - Pipeline> Service Connections>Create Service Connection> select "Azure Service Connection"
![Image](https://github.com/user-attachments/assets/e10917fd-fb50-4971-af44-092d36c49e3d)
![Image](https://github.com/user-attachments/assets/e2199467-ae79-4ad4-a679-cd7a5eb22610)
![Image](https://github.com/user-attachments/assets/8b5f1b92-0891-43c8-9a58-5ca27427952c)
![Image](https://github.com/user-attachments/assets/1e7020fc-8a7d-4c68-bb7a-9b101ce8dc55)
![Image](https://github.com/user-attachments/assets/ea313399-e8b3-402d-8cb1-875f6e698b27)
![Image](https://github.com/user-attachments/assets/1fe802f7-bb27-4df1-af33-9b1ca6d19188)

### <span style="color: cyan;"> Configure Selft-hosted Linux Agent.
- Need to configure Self-hosted Linux agents/[integrate](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/linux-agent?view=azure-devops) to azure DevOps

- Take putty session of the virtual machine and follow the below procedure to configure the self hosted agent in pipeline.

```sh
cd myagent
azureuser@devopsdemovm:~/myagent$ ls -l
total 144072
drwxrwxr-x 26 azureuser azureuser     20480 Nov 13 10:54 bin
-rwxrwxr-x  1 azureuser azureuser      3173 Nov 13 10:45 config.sh
-rwxrwxr-x  1 azureuser azureuser       726 Nov 13 10:45 env.sh
drwxrwxr-x  7 azureuser azureuser      4096 Nov 13 10:46 externals
-rw-rw-r--  1 azureuser azureuser      9465 Nov 13 10:45 license.html
-rw-rw-r--  1 azureuser azureuser      3170 Nov 13 10:45 reauth.sh
-rw-rw-r--  1 azureuser azureuser      2753 Nov 13 10:45 run-docker.sh
-rwxrwxr-x  1 azureuser azureuser      2014 Nov 13 10:45 run.sh
-rw-r--r--  1 root      root      147471638 Nov 13 12:22 vsts-agent-linux-x64-4.248.0.tar.gz
```

Update the ./config.sh Command: 
```
  **project: Nike-Website**: Specifies the project name for scoping.
  **pool: nike-website-pool**: Links the agent to the specific project-level pool.
```
```sh
# Configuration of the self-hosted agent
cd myagent
./config.sh --unattended --url https://dev.azure.com/<OrganizationName> --auth pat --token <Tocken_value> --pool <nike-website-pool> --agent aksagent --acceptTeeEula
# Start the agent service
sudo ./svc.sh install
sudo ./svc.sh start
```

![Image](https://github.com/user-attachments/assets/9ecd3e17-a534-4269-a88c-4f531b088f4e)

- **Steps to Configure the Agent for Project Context:**
  - Log in to the Azure DevOps portal.
  - Agent Pool is already create at the Project Level:
  - Navigate to your organization (https://dev.azure.com/<Organization_name>).
  - Open the Nike-Website project.
  - Go to Project Settings > Agent Pools.
    ![Image](https://github.com/user-attachments/assets/a82eab75-70a8-4a3b-9204-884c59ee1d81)
  
  - Pool to link **existing one**.
  
    ![Image](https://github.com/user-attachments/assets/d8858e54-cfdc-48e0-8f9a-523f7a1205a7)

- Verify the Agent Registration in DevOps Portal:
  - After running the command, the agent should be registered in the nike-website-pool.
  - Select the Organization> Organization setting> Pipeline> Agent Pools
    ![alt text](/All_ScreenShot/image-4.png)
  - *Go to Nike-Website > Project Settings > Agent Pools to confirm the agent is listed and active.*
  ![Image](https://github.com/user-attachments/assets/89e72f00-50bb-4675-a934-b010a02018b7)


### <span style="color: cyan;"> Set Permission for azure Artifact.
  - To add the permission
  ![Image](https://github.com/user-attachments/assets/3fa984da-076a-4beb-ac74-9f74678ea724) 
  
  - Add the following permission to make it working pipeline.
  ![Image](https://github.com/user-attachments/assets/29bbba1e-4314-442a-b15b-f88673f30524)
  ![Image](https://github.com/user-attachments/assets/412ef3a5-cdfc-4662-8df4-661196dfb43e)

## <span style="color: cyan;"> Configure CI Pipeline.
- Configure Build pipeline.

![Image](https://github.com/user-attachments/assets/24ea0620-5143-4fc3-a04d-9b1bca1a98ff)
![Image](https://github.com/user-attachments/assets/977f8b8c-2a9b-4a75-8fc5-8bf0dbb25c93)
![Image](https://github.com/user-attachments/assets/7e8d73bc-b0ec-4b17-b36d-362f4fa1d5ce)

### <span style="color: cyan;"> Build and install npm
![Image](https://github.com/user-attachments/assets/e2f5f5f2-8f8d-443a-be2f-a5e0c30c54ef)
```sh
stages:
  - stage: Build
    jobs:
    - job: Build
      steps:
      - task: Npm@1
        inputs:
          command: 'custom'
          customCommand: 'install -D tailwindcss postcss autoprefixer'
      - task: Npm@1
        inputs:
          command: 'custom'
          customCommand: 'run build'
```
### <span style="color: cyan;"> To add stage to publish the aritifact.

![Image](https://github.com/user-attachments/assets/cfdf5e5f-33e4-4f96-917d-a0ec120cb060)

```sh
- task: Npm@1
        inputs:
          command: 'publish'
          workingDir: './dist'
          publishRegistry: 'useFeed'
          publishFeed: 'c420a86b-fd1f-4e29-90eb-17d488d300b6/d00f33c5-ab18-4698-8ce1-39601d6af518'
```

- Run the pipeline and it works.
![Image](https://github.com/user-attachments/assets/804bafd7-bb77-4262-b8f2-00b6d44f679d)
![Image](https://github.com/user-attachments/assets/43730b9f-7359-490e-8a51-7080ba43c91c)

- Validate the package in Artifact
![Image](https://github.com/user-attachments/assets/0883814c-fa4e-40d9-842e-ac0ce73ca2cb)

- 👉[Here is CI Pipeline](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/07.1_Real-Time-DevOps-Project_CI-CD_WebApp_ArtiFact_Selfhosted_Agent/Pipeline_Code/CI_only.md)👈 

## <span style="color: cyan;"> Configure CD Pipeline.
- Release Pipeline
  ![Image](https://github.com/user-attachments/assets/015e3455-1c09-46c3-99c3-37419bb79d12)
  ![Image](https://github.com/user-attachments/assets/61761608-58f3-4dbb-bcde-d711ec299369)

- Rename the stage
  ![Image](https://github.com/user-attachments/assets/225e2897-c5a8-4048-9807-4eeac3ab0260)

- Add the artifact
  ![Image](https://github.com/user-attachments/assets/1641410e-e8ec-448b-9742-4727813d2119)
  ![Image](https://github.com/user-attachments/assets/e743cae3-e7df-45ad-a94d-f0de55ad277e)

- Configure stage for Deployment
  - Add sevice principal in deployment
  ![Image](https://github.com/user-attachments/assets/5f74451c-6d6a-4cb1-bdc4-6bf8fbb9561e)
  ![Image](https://github.com/user-attachments/assets/9bd6c098-7504-44f1-ad70-d3abacc09e17)
  ![Image](https://github.com/user-attachments/assets/fb2ab50d-b953-4584-87c1-d4e4afb8fdea)

  - Select the `custom agent pool` name
    ![Image](https://github.com/user-attachments/assets/d3a74c93-f49b-4e40-932e-312f46039de2)
  
  - Configure `application` in pipeline.

    - location for `Package or folder`
    ![Image](https://github.com/user-attachments/assets/b4fd4421-24b9-4aa9-a564-0858d35a45a1)
    - Runtime stack & Deployment Script | Inline Script:
    ![Image](https://github.com/user-attachments/assets/6b58a2f4-cbf7-4c78-9131-3a992f6ae060)
      ```sh
      cp -rf /home/site/wwwroot/package/* /home/site/wwwroot/
      ```
      click save.

  - Enable the trigger for auto deployment
    ![Image](https://github.com/user-attachments/assets/131e51dd-826f-4463-b786-16a6aebdf313)
    ![Image](https://github.com/user-attachments/assets/9ff2a7c4-785b-4203-ac6e-4a6df5d42081)

### <span style="color: cyan;"> CD Pipeline Status.
  ![Image](https://github.com/user-attachments/assets/3e9979ab-348e-4b69-8fde-b3ed2c0b0d09)

## <span style="color: cyan;"> Application Accessibility
  Congratulations :-) the application is working and accessible.🔥

  ![Image](https://github.com/user-attachments/assets/a2bf9875-92d3-4c8e-87b5-96968138f33a)

  - if you face any issue then go to webapp and check the logs.

## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete 

  run the terraform command.
  ```bash
  Terraform destroy --auto-approve
  ```
  ![Image](https://github.com/user-attachments/assets/b9568869-fb16-4f16-8c9e-4001e5f23c86)


## <span style="color: Yellow;"> Conclusion

This guide demonstrates the process of setting up a CI/CD pipeline using Azure DevOps and Azure Artifacts. By following these steps, you can efficiently manage and deploy applications with enhanced control over package management and deployment processes. Ensure to clean up resources after completing the deployment to avoid unnecessary charges.


__Ref Link:__

- [Azure Artifacts | Azure DevOps CI CD Pipeline- YouTube](https://www.youtube.com/watch?v=krK4HTmaCJc)
  
- [pipelines troubleshooting](https://learn.microsoft.com/en-us/azure/devops/pipelines/troubleshooting/troubleshooting?view=azure-devops)

- [Create an Account in Azure DevOps](https://www.youtube.com/watch?v=A91difri0BQ)

- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

- [Install AWS Cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

- [What is Azure Pipelines?](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops)

- [Two type of Azure Devops pipeline(YAML vs Classic Pipelines)](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/pipelines-get-started?view=azure-devops) 

- [Sonarqube](https://github.com/mc1arke/sonarqube-community-branch-plugin?tab=readme-ov-file)
  - [Sonarqube1](https://hub.docker.com/r/mc1arke/sonarqube-with-community-branch-plugin)