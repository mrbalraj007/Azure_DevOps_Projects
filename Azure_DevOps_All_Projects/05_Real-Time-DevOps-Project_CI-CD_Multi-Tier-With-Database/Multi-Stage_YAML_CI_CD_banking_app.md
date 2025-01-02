# <span style="color: Yellow;"> Azure DevOps Multi-Stage YAML CI/CD Pipeline </span>

![Azure DevOps Voting App](https://github.com/user-attachments/assets/056cf9c3-1914-4f7a-bd0f-e763b64e08ac)

This document provides a step-by-step guide on setting up a multi-stage YAML CI/CD pipeline in Azure DevOps. The pipeline includes setting up an Azure account, creating an organization, setting up a project, writing a YAML pipeline, and deploying an application to an AKS cluster.

## <span style="color: Yellow;"> Prerequisites </span>

Before diving into this project, here are some skills and tools you should be familiar with:

- [x]  Setting Up Azure Account
    1. Go to [Azure Portal](https://portal.azure.com).
    2. Create a new Microsoft account if you don't have one.
    3. Provide necessary details like name, mobile number, and payment information.

- [x] Creating Azure DevOps Organization
    1. Go to [Azure DevOps](https://dev.azure.com).
    2. Create a new organization.
    3. Set up a new project within the organization.

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/05_Real-Time-DevOps-Project_CI-CD_Multi-Tier-With-Database)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
    - Update ```terraform.tfvars```.
 
- [x] [App Repo (Banking App)](https://github.com/jaiswaladi246/Multi-Tier-With-Database)

- [x] __Azure Account__: You’ll need an Azure account to create resources like virtual Machine, AKS cluster, and manage pipelines.
- [x] __Terraform Knowledge__: Familiarity with Terraform to provision, manage, and clean up infrastructure.
- [x] __Basic Kubernetes (AKS)__: A basic understanding of Kubernetes, especially Azure AKS, to deploy and manage containers.
- [x] __Docker Knowledge__: Basic knowledge of Docker for containerizing applications.
- [x] __GitHub__: Experience with GitHub for version control and managing repositories.
- [x] __Command-Line Tools__: Basic comfort with using the command line for managing infrastructure and services.
- [x] __Basic CI/CD Knowledge__: Some understanding of Continuous Integration and Deployment is recommended.
- [x] __Azure Container Registry (ACR)__: Set up ACR to store your Docker images.
- [x] __Linux VM__: Docker must be installed on a Linux virtual machine to run containers.


## <span style="color: Yellow;">Setting Up the Infrastructure </span>

I have created a Terraform code to set up the entire infrastructure, including the installation of required applications, tools, and the AKS cluster automatically created.

**Note** &rArr;<span style="color: Green;"> ```AKS cluster``` creation will take approx. 10 to 15 minutes.

- &rArr; <span style="color: orange;">Virtual machines will be created named as ```"devopsdemovm"```

- &rArr;<span style="color: brown;"> Docker Install
- &rArr;<span style="color: brown;"> Azure Cli Install
- &rArr;<span style="color: brown;"> KubeCtl Install
- &rArr;<span style="color: brown;"> AKS Cluster Setup
- &rArr;<span style="color: brown;"> Sonarqube Install
- &rArr;<span style="color: brown;"> Trivy Install
- &rArr;<span style="color: brown;"> Maven Install

### <span style="color: Yellow;"> Virtual Machine creation

First, we'll create the necessary virtual machines using ```terraform``` code. 

Below is a terraform Code:

Once you [clone repo](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/05_Real-Time-DevOps-Project_CI-CD_Multi-Tier-With-Database)</span> and run the terraform command.
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

Once you run the terraform command, we will verify the following things to ensure everything is set up via a terraform.

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
- [x] <span style="color: brown;"> Trivy version
```bash
azureuser@devopsdemovm:~$ trivy --version
Version: 0.58.1
Vulnerability DB:
  Version: 2
  UpdatedAt: 2024-12-31 18:16:49.801727569 +0000 UTC
  NextUpdate: 2025-01-01 18:16:49.801727188 +0000 UTC
  DownloadedAt: 2024-12-31 23:32:58.310973832 +0000 UTC
Java DB:
  Version: 1
  UpdatedAt: 2024-12-30 05:06:53.947339247 +0000 UTC
  NextUpdate: 2025-01-02 05:06:53.947339087 +0000 UTC
  DownloadedAt: 2025-01-01 00:25:50.06486541 +0000 UTC
}
```
- [x] <span style="color: brown;"> Maven version
```bash
azureuser@devopsdemovm:~$ mvn --version
Apache Maven 3.6.3
Maven home: /usr/share/maven
Java version: 17.0.13, vendor: Ubuntu, runtime: /usr/lib/jvm/java-17-openjdk-amd64
Default locale: en, platform encoding: UTF-8
OS name: "linux", version: "6.5.0-1025-azure", arch: "amd64", family: "unix"
azureuser@devopsdemovm:~$
```

## <span style="color: Yellow;"> Step-by-Step Process:</span>

**1. Setting up Azure DevOps Pipeline:**
- **Create an Azure DevOps Organization:** If you don’t have one already, create a new Azure DevOps organization where your repositories and pipelines will reside.
- **Set up Agent Pool:** Define an agent pool in Azure DevOps, which will handle the execution of your pipelines.
- **Install Docker on the Agent:** Docker needs to be installed on the machine that will run the pipeline. Without Docker, you won’t be able to build or push Docker images.
  
**2. Creating the Pipeline for Build and Push:**
- **Define Pipeline YAML:** Write a YAML configuration file to define the pipeline. This file specifies stages like build and push, and Docker is used to automate the creation of images.
- **Configure Docker Build:** In the build stage, Docker is used to build images from your Dockerfile. The push stage uploads these images to the Azure Container Registry (ACR).
- **Configure Pipeline Triggers:** Set up the pipeline to trigger automatically when changes are made in specific directories, like results or worker. This helps in managing microservices by triggering pipelines only for the relevant components.
  
**3. Testing the Pipeline:**
- **Make Changes and Test:** After setting up the pipeline, make minor changes to test whether the pipeline triggers as expected. For instance, adding a space to a Dockerfile or modifying a JavaScript file in the results directory should trigger a build for that microservice only.
- **Verify Docker Image Creation:** Ensure the Docker images are being built and pushed to ACR without issues.
- **Handle Platform-Specific Builds:** If the pipeline fails due to architecture issues, ensure the correct platform (Linux/ARM64) is specified in the Dockerfile.


## <span style="color: Yellow;"> Writing YAML Pipeline </span>
1. **Trigger Configuration**: Define the trigger for the pipeline.
2. **Pool Definition**: Specify the agent pool and agent.
3. **Stages**:
    - **Compile Stage**: Compile the application using Maven.
    - **Test Stage**: Run unit tests using Maven.
    - **Trivy File System Scan**: Scan the file system using Trivy.
    - **SonarQube Analysis**: Perform code analysis using SonarQube.
    - **Publish Artifacts**: Publish build artifacts to Azure Artifacts.
    - **Docker Build**: Build Docker image.
    - **Docker Publish**: Publish Docker image to ACR.
    - **Deploy to AKS**: Deploy the application to AKS.


### <span style="color: Yellow;">**Step-01: Create project in Azure DevOps**
  - Open the Azure UI and DevOps portal ```https://dev.azure.com/<name>```
  - Create a new project
    - Git clone: https://github.com/jaiswaladi246/Multi-Tier-With-Database
 ![image-7](https://github.com/user-attachments/assets/199f58fd-c1d4-46c4-8dd8-78b7c99db790)

### <span style="color: Yellow;">**Step-02: Clone the Repo in Azure DevOps**
  - Clone the repo :: 
    - click on Import a repository
![image-4](https://github.com/user-attachments/assets/53dbdf83-3556-48fd-be1a-0d9a947f0d3f)
![image-5](https://github.com/user-attachments/assets/72b9064f-3da3-4a56-ba79-4fbd0da1161d)
![image-6](https://github.com/user-attachments/assets/efda7e38-328e-4900-b2b8-1a5048a78d31)


- #### <span style="color: Yellow;"> Create/Configure a pipeline in Azure DevOps.
  - Click on Pipeline:
   - follow the below instruction


- Click on pipeline and build it 
![image-15](https://github.com/user-attachments/assets/1569057a-b780-47fe-8272-236869de1a36)
![image-16](https://github.com/user-attachments/assets/b107209b-4d3e-4e0f-8fcd-969b61c43e15)
![image-8](https://github.com/user-attachments/assets/a3f02167-7b1e-46dd-8c66-7dadb0d7f4a1)
![image-18](https://github.com/user-attachments/assets/646a7063-9021-445f-9123-9be24ecd9c53)
    
  - It will ask you to log in with your Azure account. Please use the same login credentials that you have set up for the Azure portal.

  - Select the container registry
![image-7](https://github.com/user-attachments/assets/ebc5630e-d798-45d5-8688-2fe602defb3c)


  - **Note:** Key concept overview of pipeline.
![image-9](https://github.com/user-attachments/assets/2c902e33-4243-4171-a666-9d0eb5743120)


  - you will see the following pipeline yaml and we have to modify accordingly.
![image-8](https://github.com/user-attachments/assets/ab975781-a81a-41b7-bc2c-fa0686ac518b)

  - First, we will create a folder in the repo called 'scripts' and update the sh file as shown below. We will create a shell script to get an updated image tag if it is creating a new image.
![image-55](https://github.com/user-attachments/assets/43b96a06-d27c-46bf-b24a-1c0d7196f55a)
![image-80](https://github.com/user-attachments/assets/dd1b68b4-5e89-4f34-895f-1381eb513e9c)


  - Don't forget to update the container registroty name in the script file.
![image-23](https://github.com/user-attachments/assets/f74f2934-17d8-477a-a964-b725ab67e672)


- ### <span style="color: Yellow;">**Step-03: To configure Self-hosted Linux agents in Azure DevOps**
 
 
   - Self-hosted Linux agents/[integrate](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/linux-agent?view=azure-devops) to azure DevOps
   - select the project and project setting:
![image-24](https://github.com/user-attachments/assets/1aa1583a-08aa-487f-8474-012ca5a72288)
![image-12](https://github.com/user-attachments/assets/27299cbd-4588-4cec-ae89-70667015d8b2)
![image-13](https://github.com/user-attachments/assets/2b19c543-db44-4736-ad93-43a8e30544af)
![image-14](https://github.com/user-attachments/assets/0d24cff6-99bc-4055-acf0-8eaeb14539bd)
  - Select the agent pools name, you can choose any name 
    - devops-demo_vm 
   ![image-15](https://github.com/user-attachments/assets/23084fd1-3dfd-415c-8a81-9aa264690c0a)
   ![image-16](https://github.com/user-attachments/assets/fdf5d367-ba38-4261-bd09-56284907f384)

  - Run the following command as part of setting up the agent server. We have already installed the agent.
<!-- ```sh
mkdir myagent && cd myagent
sudo wget https://vstsagentpackage.azureedge.net/agent/4.248.0/vsts-agent-linux-x64-4.248.0.tar.gz
tar zxvf vsts-agent-linux-x64-4.248.0.tar.gz
``` -->

```sh
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

  - Configure the agent

```bash
~/myagent$ ./config.sh

Type 'Y'

#Server URL
Azure Pipelines: https://dev.azure.com/{your-organization}

# https://dev.azure.com/mrbalraj
```

  - **Need to create a PAT access Token-** 
    - Go to azure devops user setting and click on PAT.
![image-17](https://github.com/user-attachments/assets/bcba6e48-3cec-4f3b-89d1-8b2b8fdd9d21)
![image-18](https://github.com/user-attachments/assets/597e4b8d-8fc9-4b51-a7c7-6d276d82be62)
![image-19](https://github.com/user-attachments/assets/3f298f04-4bc1-4cc1-98a4-a11573369257)

- Give any name for agent
```sh
agent-1   # I used this in pipeline.
or
devops-demo_vm
```
![image-20](https://github.com/user-attachments/assets/4a52c9b4-60e4-4c1b-b5a7-227786e0b3b0)

Agent is still offline.
![image-21](https://github.com/user-attachments/assets/d2d4ef96-53cb-41cf-959e-e3229c47544d)

  - We have to Optionally run the agent interactively. If you didn't run as a service above:
```powershell
~/myagent$ ./run.sh &
```
  - Now, Agent is online ;-)
  ![image-22](https://github.com/user-attachments/assets/72bf3b1f-db9e-4ebc-b7c7-0008a7f477ba)

 - **Need to update**- the following info as well<br>
  ![image-25](https://github.com/user-attachments/assets/dd9ddd60-c895-449f-83b9-d66fd9564030)
  ![image-26](https://github.com/user-attachments/assets/426704f5-877d-434b-bf12-fbf69387051c)
  ![image-27](https://github.com/user-attachments/assets/76a384fa-ece3-427e-960a-a4adbb89ef81)
  ![image-28](https://github.com/user-attachments/assets/77b7fca9-604c-4a14-bd5c-5c884322c612)
  ![image-29](https://github.com/user-attachments/assets/d4ac6e83-af34-4bd0-bf65-3e30b65ee540)


### <span style="color: Yellow;">**Step-04: Setup AKS Cluster**</span>
  - Go Azure UI and select the AKS cluster 
  ![image-69](https://github.com/user-attachments/assets/72890d18-4698-4d12-864b-b61e493b02d1)
  ![image-70](https://github.com/user-attachments/assets/6b1ce124-10dc-4384-a370-add50bf1cce0)
  ![image-71](https://github.com/user-attachments/assets/61df9213-b7fc-4fbd-9e2b-dca92839e776)


  - Take a Putty session of the Azure VM and follow these instructions to log in to Azure and Kubernetes.

  - **Azure login**: Missing Browser on Headless Servers, Use the --use-device-code flag to authenticate without a browser:
    ```
    az login --use-device-code
    ```
    ![image-30](https://github.com/user-attachments/assets/c091888a-bcb3-4bfd-a726-aa4466225ff4)

  - https://microsoft.com/devicelogin Open this URL in a new browser and enter the code you see in the console..
![image-31](https://github.com/user-attachments/assets/1c2a3c10-a532-48e7-aafe-25230ced23b6)
![image-32](https://github.com/user-attachments/assets/ef18f082-e414-4030-83ed-a80baffffc57)

  - To list out all the account
  ```sh
  az account list --output table
  ```
  ![image-33](https://github.com/user-attachments/assets/32d77aa4-6bb6-4c2f-920b-2b1fd14a10b9)

  - To get resource details
  ```sh
  az aks list --resource-group "resourceGroupName" --output table
  ```
  ![image-34](https://github.com/user-attachments/assets/15c66017-5b79-4cfe-b3fe-603b2a4197aa)
  ![image-35](https://github.com/user-attachments/assets/081e2c85-4c47-4ff8-bfc7-fefcacd476b6)

  - [x] <span style="color: brown;"> Verify the AKS cluster.
  - To get credentails for AKS
  ```sh
  az aks get-credentials --name "Clustername" --resource-group "ResourceGroupName" --overwrite-existing

  kubectl config current-context
  kubectl get nodes
  kubectl get nodes -o wide
  ```
  ![image-36](https://github.com/user-attachments/assets/84252f38-7754-4bb9-bd2d-5eca24d34fa5)


### <span style="color: Yellow;">**Step-05: Install SonarQube Extension.**</span>
 - Now, we will integrate SonarQube into the same pipeline. We need to search for it in the marketplace and select SonarQube as shown below.
![image-38](https://github.com/user-attachments/assets/9fd80f5b-e9e1-4369-8dd4-58a57e16758e)
![image-39](https://github.com/user-attachments/assets/d7b9aa47-3b90-450a-ad29-a6669d1a603b)
![image-40](https://github.com/user-attachments/assets/146f1783-746a-489e-bc32-8247edbf4448)

Select the organization
![image-41](https://github.com/user-attachments/assets/ae6703b6-bb56-4cbc-9bab-517301154572)
![image-42](https://github.com/user-attachments/assets/3fd6fcd4-827d-4c84-865a-36520fe86dca)


### <span style="color: Yellow;">**Step-06: Setup SonarQube.**</span>
 - Note the agent's public IP address and try to access it on port ```9000```.
  - <publicIPaddressofVM:9000>  
![image](https://github.com/user-attachments/assets/1da18ea8-50d0-4be0-b32b-a43d845a66b1)
![image-1](https://github.com/user-attachments/assets/e3da4ebd-c291-487c-9c90-7a3311635926)
![image-2](https://github.com/user-attachments/assets/d3031b16-86df-4aac-8a63-46c9b6cc7911)
![image-3](https://github.com/user-attachments/assets/a89457c0-6d15-4784-bcd8-6eb2efde6c06)

#### <span style="color: Yellow;">**Step-06.1: Generate the SonarQubeToken**</span>
![image-48](https://github.com/user-attachments/assets/1a5a4bd3-268e-4062-b38b-ea9ab9d03e3a)
![image-49](https://github.com/user-attachments/assets/0498387c-a463-4314-83ce-bee6200f0741)


### <span style="color: Yellow;">**Step-07: Create Service Principle Account**</span>
- Will create a [service principle account](https://www.youtube.com/watch?v=CUHtHGS4xEc&list=PLJcpyd04zn7rxl0X8mBdysb5NjUGIsJ7W&index=3).
- Take putty session of Agent VM and do the following
```sh
az login --use-device-code
```
![image-84](https://github.com/user-attachments/assets/f1f4e869-4076-44b3-9c3b-81043d80b2b5)

- To create a SP account
```sh
az ad sp <name_of_SP> --role="contributor" --scope="subscriptions/SUBSCRIPTION_ID"
```
![image-85](https://github.com/user-attachments/assets/24c5abbf-2501-4e5a-b45e-e51aca6707a4)

### <span style="color: Yellow;">**Step-08: Configure the Service Connection for "```Azure Resource Manager```"**</span>
   - Steps to configure connection for [Azure Resource Manager](https://learn.microsoft.com/en-us/azure/devops/pipelines/release/configure-workload-identity?view=azure-devops&tabs=managed-identity):

![image-17](https://github.com/user-attachments/assets/8e77bdc8-4c48-42c8-8ceb-92d7a0ab0dc8)
![image-86](https://github.com/user-attachments/assets/d274d09b-1b45-4168-842c-f548386090de)
![image-87](https://github.com/user-attachments/assets/9e1cc145-5490-4298-b4fb-dd7b0e633e30)

### <span style="color: Yellow;">**Step-09: Configure the Service Connection for"```SonarQube```, ```Docker registory``` and ```AKS Cluster``` **</span>

  - Select the project and project setting:
    - Steps to configure connection for SonarQube:
![image-9](https://github.com/user-attachments/assets/8d10a5f5-f608-47e8-bae0-308efd0148ab)
![image-10](https://github.com/user-attachments/assets/405d3300-0c8b-49f5-ad2a-6a45a9fdda4b)

    - Steps to configure connection for Dockerregistory:
![image-11](https://github.com/user-attachments/assets/b8dd8c30-1740-4df7-97bc-2d2aec9d5252)
![image-12](https://github.com/user-attachments/assets/f3fa571e-cb34-4580-8f74-327c41e7941c)

    - Steps to configure connection for Kubernetes:
![image-13](https://github.com/user-attachments/assets/bdbaf9e1-1bb6-4ef1-8ef8-ca35cca94ca3) 
    - A popup will appear asking for login credentials. Use the same credentials you used for the UI portal login.



### <span style="color: Yellow;">**Step-10: Step by Step YAML configuration**</span>
  - Configure the Maven (Package)
![image-34](https://github.com/user-attachments/assets/26bbec50-e8f4-4553-90bb-7ab328a8cf4b)
![image-44](https://github.com/user-attachments/assets/2cf6cfee-98ac-407f-8886-efe96e0a7c34)

  - **Stage** To add maven compile
```sh
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger:
- none

pool:
  name: devops-demo_vm
  demands: agent.name -equals agent-1

stages:
- stage: CompileJob
  displayName: 'Maven Compile'
  jobs:
  - job: maven_compile
    displayName: 'maven_compile'
    steps:
     - task: Maven@4
       inputs:
         azureSubscription: 'azure-conn'
         mavenPomFile: 'pom.xml'
         goals: 'compile'
         publishJUnitResults: true
         testResultsFiles: '**/surefire-reports/TEST-*.xml'
         javaHomeOption: 'JDKVersion'
         mavenVersionOption: 'Default'
         mavenAuthenticateFeed: false
         effectivePomSkip: false
         sonarQubeRunAnalysis: false
```

  - **Stage** To add maven Test
![image-45](https://github.com/user-attachments/assets/4d0b426f-051c-4bef-9973-20076f5abaa4)
![image-46](https://github.com/user-attachments/assets/761a1024-0c3a-477d-ba01-63dec6415c3a)

```sh
- stage: Test
    displayName: 'Maven Test'
    jobs:
      - job: maven_test
        displayName: 'Unit_Test'
        steps:
          - task: Maven@4
            inputs:
              azureSubscription: 'azure-conn'
              mavenPomFile: 'pom.xml'
              goals: 'test'
              publishJUnitResults: true
              testResultsFiles: '**/surefire-reports/TEST-*.xml'
              javaHomeOption: 'JDKVersion'
              mavenVersionOption: 'Default'
              mavenAuthenticateFeed: false
              effectivePomSkip: false
              sonarQubeRunAnalysis: false      
```

  Run the pipeline to validate it.
![image-50](https://github.com/user-attachments/assets/170da4b0-599c-47ff-9d57-534ac877e158)


  - Stage: To add for Trivy

![image-47](https://github.com/user-attachments/assets/2ed4f328-087d-436c-b3f3-c137ed81d2ce)

```sh
# Add Trivy FS scan image.
  - stage: Trivy_FS_Scan
    displayName: 'Trivy_FS_Scan'
    jobs:
      - job: Trivy_FS_Scan
        displayName: 'Trivy FS Scan'       
        steps:
          - task: CmdLine@2
            inputs:
              script: 'trivy fs --format table -o trivy-fs-report.html .'
```

  - **Stage** To Add for SonarQube
  
    - taking help from helper task as below to complete the stage for sonarqube
![image-19](https://github.com/user-attachments/assets/3210d418-a537-4141-b4fe-19450200894f)
![image-20](https://github.com/user-attachments/assets/cc8b6707-0a8a-42a5-89cb-067cd6dcb058)
![image-21](https://github.com/user-attachments/assets/7aa578f0-61f7-4f75-bded-7fa81a759ccd)
![image-22](https://github.com/user-attachments/assets/376c676d-c86b-4ab4-8ae3-2aeab908cc41)

```sh
# Add SonarQube  
  - stage: SonarQube
    displayName: 'SonarAnalysis'
    jobs:
      - job: SonarQube_analysis
        steps:
          - task: SonarQubePrepare@7
            inputs:
              SonarQube: 'sonar-conn'
              scannerMode: 'cli'
              configMode: 'manual'
              cliProjectKey: 'bankapp'
              cliProjectName: 'bankapp'
              cliSources: '.'
              extraProperties: 'sonar.java.binaries=.' 
          - task: SonarQubeAnalyze@7
            inputs:
              jdkversion: 'JAVA_HOME_17_X64'
```

Run the pipeline to validate it.
![image-54](https://github.com/user-attachments/assets/172d8b42-2f98-4d9a-ae18-42cc0c437c3c)

  - **Stage** To SonarQube for analysis.
![image-53](https://github.com/user-attachments/assets/09c3ea90-57a4-4ff9-88bb-b52a5e24afdb)

  - **Stage** To add build package and publish artifacts
    - Add build package stage and publish artifacts into ```Azure artifacts```.
![image-55](https://github.com/user-attachments/assets/5defbc69-cef3-4b06-a791-51c4de0e17ce)
![image-57](https://github.com/user-attachments/assets/1a1feda7-1d54-4edc-a30a-0647f60cbbe3)
click on setting and change the permission as below.
![image-58](https://github.com/user-attachments/assets/37d7c6ea-6f41-4892-a10e-6bcb7b50cba8)
![image-59](https://github.com/user-attachments/assets/71437395-6d6a-4e8e-bc01-bccdb616c25f)


build the project and then add maven Authentication
![image-62](https://github.com/user-attachments/assets/3c9d5150-5b4d-4d0e-bf52-879fb7bc15fc)
![image-63](https://github.com/user-attachments/assets/9adf38db-dae0-45f0-98dc-79e900d141c4)

![image-60](https://github.com/user-attachments/assets/9a6204fb-40d8-40c6-8511-2d1f8eb57f87)
![image-61](https://github.com/user-attachments/assets/64e1f174-7b24-4bee-8f89-708ec7bed902)

```sh
# To Publish the Artifacts.
  - **Stage** Publish_Artifact
    displayName: 'Publish_Build_Artifacts'
    jobs:
      - job: publish_artifacts
        displayName: 'Publish_build_Artifacts'
        steps:
          - task: MavenAuthenticate@0
            inputs:
              artifactsFeeds: 'store_artifact_maven'
          - task: Maven@4
            inputs:
              azureSubscription: 'azure-conn'
              mavenPomFile: 'pom.xml'
              goals: 'deploy'
              publishJUnitResults: true
              testResultsFiles: '**/surefire-reports/TEST-*.xml'
              javaHomeOption: 'JDKVersion'
              mavenVersionOption: 'Default'
              mavenAuthenticateFeed: false
              effectivePomSkip: false
              sonarQubeRunAnalysis: false       
```

  - next step would be, click the ```artifacts```
![image-23](https://github.com/user-attachments/assets/4212a003-48a8-41eb-835a-408ae0a8d00c)
![image-64](https://github.com/user-attachments/assets/85d6700a-b750-4239-88ad-c845d0c040a8)
![image-65](https://github.com/user-attachments/assets/c023ffb2-f69c-47c7-afd1-8ea92c6ff225)

Run the pipeline and status of pipeline as below-

I am getting below error message.
![image-69](https://github.com/user-attachments/assets/c0af4060-0874-447d-8af0-e508bd7d8111)

**Solution:** 
- Add the repo to both your pom.xml's ```repositories``` and ```distributionManagement``` sections.

![image-66](https://github.com/user-attachments/assets/fff81985-a89e-4f7d-9f79-51f77b4bc1e6)
replace with below and commit it.
![image-67](https://github.com/user-attachments/assets/52248806-2eb3-4454-9042-081642a048b6)
![image-68](https://github.com/user-attachments/assets/b850fe78-2ccd-409e-bba0-a7df7edbf6a2)


ReRun the pipeline and status of pipeline as below-
![image-30](https://github.com/user-attachments/assets/78097e21-5466-414a-b065-d3a38ca2198d)

Validate the artifacts:
![image-31](https://github.com/user-attachments/assets/85a1718b-5f5c-427a-83ba-5c2b366dd6c8)
![image-32](https://github.com/user-attachments/assets/899c4cf0-a483-4f4a-ae4f-fcd6c387cb0f)


  - **Stage** To Add Stage for ```Docker build image```
![image-70](https://github.com/user-attachments/assets/a16838e5-19e8-4902-ae58-82148d59cc60)


```sh
# To Docker image build and push
  - stage: Docker_Build          
    displayName: 'Docker_Build'
    jobs:
      - job: docker_build
        displayName: 'docker_build'
        steps:
          - task: CmdLine@2
            inputs:
              script: 'mvn package'
          - task: Docker@2
            inputs:
               containerRegistry: 'docker-conn'
               repository: 'dev'
               command: 'build'
               Dockerfile: '**/Dockerfile'
               tags: 'latest'
```
  - **Stage** To Add Stage for ```Trivy Image scan```

```sh
 # Add Trivy Image scan .  
  - stage: Trivy_image_Scan
    displayName: 'Trivy_image_Scan'
    jobs:
      - job: Trivy_image_Scan
        displayName: 'Trivy image Scan'       
        steps:
          - task: CmdLine@2
            inputs:
              script: 'trivy image --format table -o trivy-image-report.html aconreg6700da08.azurecr.io/dev:latest'
```

  - **Stage** To Add Stage for ```Docker Push Image```
  
```sh
# To Docker push Image
  - stage: Docker_Publish          
    displayName: 'Docker_Publish'
    jobs:
      - job: docker_Publish
        displayName: 'docker_Publish'
        steps:
          - task: Docker@2
            inputs:
              containerRegistry: 'docker-conn'
              repository: 'dev'
              command: 'push'
              tags: 'latest'
```

  - **Stage** To Add Stage for ```Deploy on AKS```
![image-71](https://github.com/user-attachments/assets/339bfcaf-d44c-4947-abac-fcd17fd9d6c9)
![image-72](https://github.com/user-attachments/assets/51c2eb38-d6df-4921-8d31-c18ff3a9ae18)

```sh
# To Deploy on K8s
  - stage: deploy_to_k8s
    displayName: 'Deploy to AKS'
    jobs:
      - job: deploy_to_k8s
        displayName: 'Deploy to AKS'
        steps:
           - task: KubernetesManifest@1
             inputs:
               action: 'deploy'
               connectionType: 'kubernetesServiceConnection'
               kubernetesServiceConnection: 'k8s-conn'
               namespace: 'default'
               manifests: 'ds.yml'
```

 - complete YAML [pipeline](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/05_Real-Time-DevOps-Project_CI-CD_Multi-Tier-With-Database/Pipeline/Updated_CI_CD/Pipine_CI.md)

Pipeline status
![image-35](https://github.com/user-attachments/assets/7b290bb3-bcea-4290-9572-bbcdce1dbe0c)
![image-36](https://github.com/user-attachments/assets/12db5c8d-83f1-4898-b5a7-da0a54fcfb29)

- update the image name in manifest file.
![image-37](https://github.com/user-attachments/assets/54564b1d-af89-4f1d-beff-603d58a7ce7e)

View status in Azure UI:from UI | K8s
![image-51](https://github.com/user-attachments/assets/08b74607-5604-4a55-8d90-eedbc835703f)
![image-52](https://github.com/user-attachments/assets/25345004-4c32-4564-aae3-d80b1f69ef8f)
![image-43](https://github.com/user-attachments/assets/9c6544b7-c4a4-4dc9-969d-509f3b7795a9)
![image-73](https://github.com/user-attachments/assets/6d7ba719-f591-4c60-a3e3-a4304696c7fd)


  - az login
![image-56](https://github.com/user-attachments/assets/da2d0642-8b38-46ec-8e0e-3f6ebf55d028)


```sh
azureuser@devopsdemovm:~$ kubectl get all
NAME                           READY   STATUS    RESTARTS      AGE
pod/bankapp-7ddf494bdd-2ljrl   1/1     Running   2 (17m ago)   18m
pod/mysql-5dcf64c95c-xqhdn     1/1     Running   0             18m

NAME                      TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
service/bankapp-service   LoadBalancer   10.0.95.5      <pending>     80:31781/TCP   18m
service/kubernetes        ClusterIP      10.0.0.1       <none>        443/TCP        3h36m
service/mysql-service     ClusterIP      10.0.151.134   <none>        3306/TCP       18m

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/bankapp   1/1     1            1           18m
deployment.apps/mysql     1/1     1            1           18m

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/bankapp-7ddf494bdd   1         1         1       18m
replicaset.apps/mysql-5dcf64c95c     1         1         1       18m


azureuser@devopsdemovm:~$ kubectl get nodes -o wide
NAME                             STATUS   ROLES    AGE     VERSION   INTERNAL-IP   EXTERNAL-IP      OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
aks-system-18075837-vmss000000   Ready    <none>   3h35m   v1.31.2   10.224.0.4    52.183.119.235   Ubuntu 22.04.5 LTS   5.15.0-1075-azure   containerd://1.7.23-1
azureuser@devopsdemovm:~$
```

Now, try to get all resources, and you will notice there is an error related to "ImagePullBackoff".

```sh
kubectl get all
```
I am getting below error message.
![image-58](https://github.com/user-attachments/assets/71922859-a009-45c5-b89c-433f30c06ac1)


**Solution**: As we are using a private registry and we need to use 'imagepullsecrets'

Go to Azure registry and get the password which will be used in the below command
![image-60](https://github.com/user-attachments/assets/5549858c-2c3e-493d-a802-c881af820477)


- Command to create ```ACRImagePullSecret```
```sh
kubectl create secret docker-registry <secret-name> \
    --namespace <namespace> \
    --docker-server=<container-registry-name>.azurecr.io \
    --docker-username=<service-principal-ID> \
    --docker-password=<service-principal-password>
```
*Explanation of the Command:*
```sh
kubectl create secret docker-registry:

- This creates a new Kubernetes secret of type docker-registry.
<secret-name>:

- The name of the secret being created. For example, acr-credentials.
--namespace <namespace>:

- Specifies the namespace in which the secret will be created. If omitted, it defaults to the default namespace.
Replace <namespace> with the desired namespace name.
--docker-server=<container-registry-name>.azurecr.io:

- The URL of your container registry. For Azure Container Registry (ACR), the format is <container-registry-name>.azurecr.io.
Replace <container-registry-name> with your ACR name.
--docker-username=<service-principal-ID>:

- The username to authenticate with the container registry. For Azure, this is typically a service principal's application (client) ID.
--docker-password=<service-principal-password>:

- The password (or secret) associated with the service principal used for authentication.
```

To get token, click on ```container registory```
![image-79](https://github.com/user-attachments/assets/20a8dff5-a911-45d5-85c5-efdbbe3fc5e1)

  - To get secret details
```sh
kubectl get secret
```
  - To create secret
```sh
kubectl create secret docker-registry acr-credentials \
    --namespace default \
    --docker-server=aconregee7b05ba.azurecr.io \
    --docker-username=aconregee7b05ba \
    --docker-password=<token>
```
![image-61](https://github.com/user-attachments/assets/5c48568e-775a-4912-aac9-6ae4e78acc8c)

- Command to delete ```secret```
 ```sh
kubectl delete secret acr-credentials --namespace default
 ``` 

now, we will update the service-deployment.yaml as below:
![image-80](https://github.com/user-attachments/assets/dd1b68b4-5e89-4f34-895f-1381eb513e9c)
![image-81](https://github.com/user-attachments/assets/acbcdc16-b457-4575-99d5-66b529e43d8f)


here is the updated service status
![image](https://github.com/user-attachments/assets/6e6758b7-f19d-44be-9400-9bfcc623e37b)

- To check the deployment
```sh
kubectl get deploy vote -o yaml
```

- Verify services and try to access the application
```sh
kubectl get svc
kubectl get node -o wide
```

```sh
kubectl describe node aks-system-18075837-vmss000000
```

Then access it at ```http://52.183.119.235:31781```.

  - If page is not opening then we have to open a port in NSG.
    - On the Azure portal, navigate to the server with VMSS and select the VMSS.
![image-74](https://github.com/user-attachments/assets/6c847f3f-b6b0-4c4c-bf43-5751396a9e42)

Now, we need to try to access it again ```http://PublicIPAddress:31781```.

![image-75](https://github.com/user-attachments/assets/63b70a22-f70d-4c23-b575-193956d94699)
![image-76](https://github.com/user-attachments/assets/6e29d1eb-30bb-4c2f-8da6-b45fbbd683f6)
![image-77](https://github.com/user-attachments/assets/12911d56-b111-43dd-8986-80639ade5910)
![image-78](https://github.com/user-attachments/assets/32cf6ef5-9355-4c22-9dde-beb77a773851)
![image-79](https://github.com/user-attachments/assets/b02fc3cb-6176-41ac-810d-27bb5c1908e2)


Congratulations :-) the application is working and accessible.

**Note**:- I have updated fully automated CI_pipeline: [Bank_App](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/05_Real-Time-DevOps-Project_CI-CD_Multi-Tier-With-Database/Pipeline/Updated_CI_CD/Pipine_CI_Updated.md)


### <span style="color: yellow;"> Step-11: Clean up the images and container registry using the pipeline..</span>

- First create [Service Connection](https://www.youtube.com/watch?v=pSmKNbN_Y4s) in Azure Devops.
- Once you create a connection, make sure to note down the connection ID, as this ID will be used in the pipeline.
- On the agent machine, ensure you are logged in with Azure and that the connection is active. If not, log in using the following steps.
  ```sh
  az login --use-device-code
  ```
    - **Using Azure DevOps CLI**
        - Install the Azure DevOps CLI extension if not already installed:
        ```sh
        az extension add --name azure-devops
        ```

    - Sign in and configure the Azure DevOps organization:
      ```sh
      az devops configure --defaults organization=https://dev.azure.com/{organization} project={project}
      ```
      * Replace {organization} and {project} with your details.

    - List service connections:
      ```bash
        az devops service-endpoint list --query "[].{Name:name, ID:id}"
        ```
      - This command will return a list of service connections with their names and IDs.
![image-33](https://github.com/user-attachments/assets/199c5e63-110c-4005-8586-1f85a503240c)

- Delete all the images along with repogitory.
    - Delete all images from CR [Repogitory]()
    
### <span style="color: yellow;"> Step-12: Environment Cleanup:</span>

- As we are using Terraform, we will use the following command to delete 

- __Delete all deployment/Service__ first
     ```sh
        kubectl delete service/bankapp-service
        kubectl delete service/mysql-service 
        kubectl delete deployment.apps/bankapp
        kubectl delete deployment.apps/mysql
        
- Now, time to delete the ```AKS Cluster and Virtual machine```.

    ```bash
    Terraform destroy --auto-approve
    ```

## <span style="color: Yellow;"> Conclusion

Following these steps, you can set up a complete CI/CD pipeline in Azure DevOps, from setting up the infrastructure to deploying an application to an AKS cluster.


__Ref Link:__

- [Youtube Link](https://www.youtube.com/watch?v=_6KjAp9h3Lo&list=PLAdTNzDIZj_8CAr71KAH9H9E1VTvywyxn&index=16)


## Additional Resources
- [Azure DevOps Documentation](https://docs.microsoft.com/en-us/azure/devops/)
- [Azure Kubernetes Service Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [SonarQube Documentation](https://docs.sonarqube.org/latest/)
- [Trivy Documentation](https://github.com/aquasecurity/trivy)

- [pipelines troubleshooting](https://learn.microsoft.com/en-us/azure/devops/pipelines/troubleshooting/troubleshooting?view=azure-devops)

- [Create an Account in Azure DevOps](https://www.youtube.com/watch?v=A91difri0BQ)

- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

- [Install AWS Cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

- [kubernetes-deploy-terraform?pivots=development-environment-azure-cli](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-terraform?pivots=development-environment-azure-cli)

- [AKS Cluster](https://developer.hashicorp.com/terraform/tutorials/kubernetes/aks)

- [create-aks-cluster-using-terraform](https://stacksimplify.com/azure-aks/create-aks-cluster-using-terraform/)


- [Pull Registory](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)

- [What is Azure Pipelines?](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops)

- [YAML vs Classic Pipelines (Two type of Azure Devops pipeline)](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/pipelines-get-started?view=azure-devops) 

- [Connect to Azure with an Azure Resource Manager service connection](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-using-workload-identity-federation)

- [sonarqube-community-branch-plugin](https://github.com/mc1arke/sonarqube-community-branch-plugin?tab=readme-ov-file)
- [sonarqube-with-community-branch-plugin](https://hub.docker.com/r/mc1arke/sonarqube-with-community-branch-plugin)
