# <span style="color: Yellow;"> Mastering Spring Boot: Building a Dynamic Secret Santa Generator Web Application using Azure DevOps </span>
The Secret Santa Generator is a web application built using Spring Boot technologies, Thymeleaf views, JPA, H2 Database, and more. It features a Spring Model, View, and Controller (MVC) architecture along with Service and Repository layers. This project is designed to facilitate the popular Christmas game "Secret Santa," where friends draw names to decide who they will give a present to.

## <span style="color: Yellow;"> Prerequisites </span>

Before diving into this project, here are some skills and tools you should be familiar with:

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/02_Real-Time-DevOps-Project_CR_AKS_with-EC2)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
    - Update ```terraform.tfvars```.
 
- [x] [App Repo (SecretSanta-Generator)](https://github.com/jaiswaladi246/secretsanta-generator.git)

- [x] __Azure Account__: You’ll need an Azure account to create resources like virtual Machine, AKS cluster, and manage pipelines.
- [x] __Terraform Knowledge__: Familiarity with Terraform to provision, manage, and clean up infrastructure.
- [x] __Basic Kubernetes (AKS)__: A basic understanding of Kubernetes, especially Azure AKS, to deploy and manage containers.
- [x] __Docker Knowledge__: Basic knowledge of Docker for containerizing applications.
- [x] __GitHub__: Experience with GitHub for version control and managing repositories.
- [x] __Command-Line Tools__: Basic comfort with using the command line for managing infrastructure and services.
- [x] __Basic CI/CD Knowledge__: Some understanding of Continuous Integration and Deployment is recommended.
- [x] __Azure Container Registry (ACR)__: Set up ACR to store your Docker images.
- [x] __Linux VM__: Docker must be installed on a Linux virtual machine to run containers.

## <span style="color: Yellow;"> Key Points </span>
- Technologies Used: Spring Boot, Thymeleaf, JPA, H2 Database
- Architecture: Spring MVC, Service, and Repository layers
- Functionality: Randomly generates Secret Santa matches
- Learning Objectives: Spring development, database management, application architecture

## <span style="color: Yellow;"> Advantages of Using This Project </span>
- Educational Value: This project is an excellent resource for learning Spring development, database management, and industry-standard application architecture.
- Practical Application: It provides a practical solution to the "Secret Santa problem," making it useful for real-world applications.
- Comprehensive Technology Stack: The project covers a wide range of technologies, including Java Spring Core, HTML5, CSS, Thymeleaf, JPA, and H2 Database.
- MVC Architecture: It demonstrates the use of MVC architecture, which is a widely adopted design pattern in web development.
- In-Memory Database: The use of H2 in-memory database allows for easy setup and testing without the need for an external database.


## <span style="color: Yellow;"> Step-by-Step Description </span>

1. **Project Setup**
   - Clone the Repository: Clone the project repository from the source control.
   - Import into IDE: Import the project into your preferred Integrated Development Environment (IDE) such as IntelliJ IDEA or Eclipse.
   - Build the Project: Use Maven or Gradle to build the project and resolve dependencies.
2. **Application Configuration**
   - Spring Boot Configuration: Configure Spring Boot application properties in application.properties or application.yml.
   - Database Configuration: Set up the H2 in-memory database configuration for development and testing purposes.
3. **Developing the Application**
   - Model Layer: Define the data models using JPA annotations.
   - Repository Layer: Create repository interfaces for data access operations.
   - Service Layer: Implement business logic in service classes.
   - Controller Layer: Develop controllers to handle HTTP requests and responses.
4. **Thymeleaf Integration**
   - View Templates: Create Thymeleaf templates for the user interface.
   - Data Binding: Bind data from the model to the view using Thymeleaf syntax.
5. **Implementing Secret Santa Logic**
   - Random Pairing Algorithm: Implement the logic to randomly generate Secret Santa matches.
   - Directed Graph Solution: Ensure the solution handles the complexities of the "Secret Santa problem" by creating a directed graph.
6. **Testing and Debugging**
   - Unit Tests: Write unit tests for the service and repository layers.
   - Integration Tests: Develop integration tests to ensure the application components work together as expected.
   - Debugging: Use the IDE's debugging tools to troubleshoot and fix any issues.
7. **Deployment**
   - Package the Application: Package the application as a JAR or WAR file.
   - Deploy to Server: Deploy the packaged application to a web server or cloud platform.

## <span style="color: Yellow;">Setting Up the Infrastructure </span>

I have created a Terraform code to set up the entire infrastructure, including the installation of required applications, tools, and the AKS cluster automatically created.

**Note** &rArr;<span style="color: Green;"> ```AKS cluster``` creation will take approx. 10 to 15 minutes.

- &rArr; <span style="color: brown;">Virtual machines will be created named as ```"devopsdemovm"```

- &rArr;<span style="color: brown;"> Docker Install
- &rArr;<span style="color: brown;"> Azure Cli Install
- &rArr;<span style="color: brown;"> KubeCtl Install
- &rArr;<span style="color: brown;"> AKS Cluster Setup

### <span style="color: Yellow;"> Virtual Machine creation

First, we'll create the necessary virtual machines using ```terraform``` code. 

Below is a terraform Code:

Once you [clone repo](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/02_Real-Time-DevOps-Project_CR_AKS_with-EC2)</span> and run the terraform command.
```bash
$ ls -l
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
dar--l          26/12/24   7:16 PM                pipeline
dar--l          23/12/24   3:38 PM                scripts
-a---l          25/12/24   2:31 PM            600 .gitignore
-a---l          26/12/24   9:29 PM           6571 VM_ACR.tf
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
## <span style="color: Yellow;"> Step-by-Step Process:</span>


### <span style="color: Yellow;">Step-01: [Create project in Azure DevOps](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/00_Real-Time-DevOps-Project_Project_Tools_Configuration/Create_project_in_Azure_DevOps.md)
  - Open the Azure UI and DevOps portal ```https://dev.azure.com/<name>```
  - Create a new project
   
### <span style="color: Yellow;">Step-02: [Clone the Repo in Azure DevOps](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/00_Real-Time-DevOps-Project_Project_Tools_Configuration/Clone_Import_Repo_in_Azure_DevOps.md)
  - Clone the repo :: 
    - click on Import a repository
    - Git clone: https://github.com/jaiswaladi246/secretsanta-generator.git
![alt text](image-7.png)


- #### <span style="color: Yellow;"> [Create/Configure a pipeline in Azure DevOps](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/00_Real-Time-DevOps-Project_Project_Tools_Configuration/Configure_a_pipeline_in_Azure-DevOps.md).
  - Click on Pipeline:
     - follow the instruction
  - Click on pipeline and build it 


### <span style="color: Yellow;">Step-03: [To configure Self-hosted Linux agents in Azure DevOps](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/00_Real-Time-DevOps-Project_Project_Tools_Configuration/To_configure_Self-hosted_Linux-agents_in_Azure-DevOps.md)
  - Need to configure Self-hosted Linux agents/[integrate](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/linux-agent?view=azure-devops) to azure DevOps
  - run the following command as part of provision the server, we have already install the agent.
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
  
```powershell
~/myagent$ ./config.sh

Type 'Y'

#Server URL
Azure Pipelines: https://dev.azure.com/{your-organization}
https://dev.azure.com/mrbalraj
```
 
- Give any name for agent
```sh
devops-demo_vm
```
- We have to Optionally run the agent interactively. If you didn't run as a service above:
```powershell
~/myagent$ ./run.sh &
```
Now, Agent is online ;-)

Additional settings needs to be done as below
![image-25](https://github.com/user-attachments/assets/d04acf33-4cbb-4743-a87f-6e17b60f588c)
![image-26](https://github.com/user-attachments/assets/efbda60f-6f20-4266-85de-35c72075cbe7)
![image-27](https://github.com/user-attachments/assets/2067905f-aff0-4a03-9f30-9f4cbbc56497)
![image-28](https://github.com/user-attachments/assets/4815ecb3-a2ad-494f-b254-df94ff2e64f8)
![image-29](https://github.com/user-attachments/assets/a676bd59-98bd-40cb-9679-53d5e9b79a1a)



### <span style="color: Yellow;">Step-04: [Setup AKS Cluster](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/00_Real-Time-DevOps-Project_Project_Tools_Configuration/Setup_AKS_Cluster.md)


 - **Note:** Key concept overview of pipeline.
![image-9](https://github.com/user-attachments/assets/2c902e33-4243-4171-a666-9d0eb5743120)

### <span style="color: Yellow;">Step-05: [Install SonarQube Extension](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/00_Real-Time-DevOps-Project_Project_Tools_Configuration/Install_SonarQube-Extension.md)
 - Now, we will integrate SonarQube into the same pipeline. We need to search for it in the marketplace and select SonarQube.

- Install SonarQube Extension.
Now, we will integrate SonarQube in same pipeline.
we have to search it in market place and select the sonarqube as below.

### <span style="color: Yellow;">**Step-06: Setup SonarQube.**</span>
 - Note the agent's public IP address and try to access it on port ```9000```.
  - <publicIPaddressofVM:9000>  

- Generate the SonarQubeToken


### <span style="color: Yellow;">Step-07: [Configure the Service Connection](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/00_Real-Time-DevOps-Project_Project_Tools_Configuration/Create_Service_Principle_Account.md)  for "```Azure Resource Manager```"
   - Steps to configure connection for [Azure Resource Manager](https://learn.microsoft.com/en-us/azure/devops/pipelines/release/configure-workload-identity?view=azure-devops&tabs=managed-identity):
  - Configure the Service Connection:
    - Select the project and project setting:
  ![image-8](https://github.com/user-attachments/assets/ff73b28a-7a05-405c-a53d-74a8e63056f4)

Will create three connection as below
- 01. SonarQube
- 02. Docker hub
- 03. AKS Cluster

- Steps to configure connection for SonarQube:
![image-9](https://github.com/user-attachments/assets/a88df64c-e251-4c87-84ea-7bcf5d43b1ba)
![image-10](https://github.com/user-attachments/assets/55b228da-c7b6-4d0b-8725-c0fe8cbe3afd)


- Steps to configure connection for DockerHub:
![image-11](https://github.com/user-attachments/assets/f43a643a-f3a4-427a-be15-8d6a6e271e9d)
![image-12](https://github.com/user-attachments/assets/cf39edf0-6505-4229-a9ae-0bf6c920a5da)

- Steps to configure connection for Kubernetes:

![image-13](https://github.com/user-attachments/assets/e91ec516-e8f8-4d91-9c21-c6cd7eaba840)

 It will popup for login crednetial and it should be used the same cred which you have used for UI portal login.

![image-14](https://github.com/user-attachments/assets/03b7512f-b460-42c2-acc8-e7ed1284dee9)

- #### <span style="color: Yellow;"> [Create/Configure a pipeline in Azure DevOps](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/00_Real-Time-DevOps-Project_Project_Tools_Configuration/Configure_a_pipeline_in_Azure-DevOps.md).
  - Click on Pipeline:
     - follow the instruction
  - Click on pipeline and build it 

![image-15](https://github.com/user-attachments/assets/b845bdac-09aa-43eb-a05e-5c751831fdb7)
![image-16](https://github.com/user-attachments/assets/b39ab0f4-48be-4f78-b93b-94bacc91f29f)
![image-17](https://github.com/user-attachments/assets/5e15877b-64b2-4ecf-9505-99977b23fbdc)
![image-18](https://github.com/user-attachments/assets/3436aa33-25a1-480d-b5ea-4f1e86a922a7)

```sh
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger:
# master   
- none

pool:
  name: devops-demo_vm
  demands: agent.name -equals agent-1

stages:
- stage: CompileJob
  displayName: 'Compile Stage'
  jobs:
  - job: CompileJob
    displayName: 'Compile Job'
    steps:
    - script: mvn compile
      displayName: 'Compile Step'

- stage: Test
  displayName: 'Test Stage'
  jobs:
  - job: TestJob
    displayName: 'Test Job'
    steps:
    - script: mvn test
      displayName: 'Test Step'

# Add Trivy FS scan image.
- stage: Trivy_FS_Scan
  displayName: 'Trivy-FS-Stage'
  jobs:
  - job: TrivyFSJob
    displayName: 'TrivyFSJob'
    steps:
    - script: trivy fs --format table -o trivy-fs-report.html .
      displayName: 'TrivyFS-Scan_Step'
```

- Add Stages for SonarQube
- taking help from helper as below to complete the stage for sonarqube
![image-19](https://github.com/user-attachments/assets/32b24738-2410-46ec-ba39-4ed6e6644bc8)
![image-20](https://github.com/user-attachments/assets/a237fed2-7a3b-4ce5-9902-6273706dd74a)
![image-21](https://github.com/user-attachments/assets/31e50cda-4c71-4700-8769-cc1f9886b852)
![image-22](https://github.com/user-attachments/assets/141ac20d-fa86-4fa1-90eb-6b82f3bd2d55)

```sh
- stage: SonarQube_Scan
  displayName: 'SonarQube-Stage'
  jobs:
  - job: SonarQubeSJob
    displayName: 'SonarQubeJob'
    steps:
    - task: SonarQubePrepare@7
      inputs:
        SonarQube: 'sonar-conn'
        scannerMode: 'cli'
        configMode: 'manual'
        cliProjectKey: 'secretsanta'
        cliProjectName: 'secretsanta'
        cliSources: '.'
        extraProperties: 'sonar.java.binaries=.'
    - task: SonarQubeAnalyze@7
      inputs:
        jdkversion: 'JAVA_HOME'
```

- add build package stage
```sh
- stage: Build
  displayName: 'Build-Stage'
  jobs:
  - job: BuildJob
    displayName: 'BuildJob'
    steps:
    - script: mvn package
      displayName: 'Build_package_Step'
```

Run the pipeline and status of pipeline as below-
![image-23](https://github.com/user-attachments/assets/6c06d300-241b-468c-941d-f45a93b5650b)


- Add Docker build and push image
![image-30](https://github.com/user-attachments/assets/9be95845-c3f7-4cd5-88eb-fb8f97139f88)
![image-31](https://github.com/user-attachments/assets/7e01241a-3011-4d5e-9b7f-87e80cc74496)

```sh
- stage: Docker
  displayName: 'Docker-Stage'
  jobs:
  - job: DockerJob
    displayName: 'Docker Job'
    steps:
    - script: mvn package
      displayName: 'Build_package_Step'
    - task: Docker@2
      inputs:
        containerRegistry: 'docker-conn'
        repository: 'balrajsi/secretsanta'
        command: 'buildAndPush'
        Dockerfile: '**/Dockerfile'
        tags: 'latest'
```

- Trivy Image scan

```sh
- stage: Trivy_Image_Scan
  displayName: 'Trivy-Image-Stage'
  jobs:
  - job: TrivyImageJob
    displayName: 'TrivyImageJob'
    steps:
    - script: trivy image --format table -o trivy-image-report.html balrajsi/secretsanta:latest
      displayName: 'TrivyImage-Scan_Step'
```
Pipeline status
![image-32](https://github.com/user-attachments/assets/96f7194a-ece1-4027-976c-2e89c1ba60b5)


- update the image name in manifest file.
![image-44](https://github.com/user-attachments/assets/7bb91d77-a8e7-4cd3-bf0b-53f76d878948)

- add K8s Stage in pipeline.
![image-35](https://github.com/user-attachments/assets/d25254b8-8e42-414a-bab3-2f672d4254ba)
![image-36](https://github.com/user-attachments/assets/6d0c927c-b159-40d8-a3b9-fde17f865b24)
![image-37](https://github.com/user-attachments/assets/bd12083b-fbe0-4d3a-a661-70a38b36778f)
![image-43](https://github.com/user-attachments/assets/3865ffc6-6a87-41e7-999d-0da093b51cf7)

```sh
- stage: K8_Deploy
  displayName: 'K8_Deploy_Stage'
  jobs:
  - job: K8s_Deploy_Job
    displayName: 'K8s_Deploy_Job'
    steps:
    - task: KubectlInstaller@0
      inputs:
        kubectlVersion: 'latest'
    - task: Kubernetes@1
      inputs:
        connectionType: 'Kubernetes Service Connection'
        kubernetesServiceEndpoint: 'k8s-conn'
        namespace: 'default'
        command: 'apply'
        useConfigurationFile: true
        configuration: 'deployment-service.yaml'
```

Run the pipeline and got below message
![image-45](https://github.com/user-attachments/assets/762353ff-852b-4ef0-8bb6-b96447c61b35)
![image-46](https://github.com/user-attachments/assets/5bf195b8-3578-42d3-9cc4-b8d469c04f7b)

Once i approved it and pipeline works fine.
![image-47](https://github.com/user-attachments/assets/b5730a0e-3732-4f64-b486-08a4b743fc3e)
![image-50](https://github.com/user-attachments/assets/424e12db-2a53-47ad-9153-13ab0ef4e9b4)


Project Status in SonarQube:
![image-33](https://github.com/user-attachments/assets/cedd208e-4858-4487-95e3-2ab7732828f7)
![image-63](https://github.com/user-attachments/assets/afd8ccd6-0d3d-401c-8e3b-556e8ce4aa51)



Image view in Docker Hub
![image-34](https://github.com/user-attachments/assets/f31b3472-6620-4214-a6c7-97ab062fa4c5)









View status in Azure UI:
![image-51](https://github.com/user-attachments/assets/6495fbdb-5abf-47d2-b265-4bcf68df552d)
![image-52](https://github.com/user-attachments/assets/aef50133-0a41-4b42-9a76-ecb17f82ddd9)
![image-53](https://github.com/user-attachments/assets/aee2924b-e3ee-4d5c-a84c-f04340753014)
![image-54](https://github.com/user-attachments/assets/a56609e4-dec9-4120-9441-0f44ba2db4d6)



On Agent VM
```sh
sudo snap install kubectl --classic
```
az login
![image-56](https://github.com/user-attachments/assets/c4bfee2d-d043-4e0f-962b-66536bc3e912)



from UI | K8s
![image-57](https://github.com/user-attachments/assets/148c933e-28ab-4659-b878-ba8f3d771410)



- First we will create a folder in repo called 'scripts' and update the sh file as below. we will create a shell script to get an updated image tag in case if it is creating new image.
![image-54](https://github.com/user-attachments/assets/3ec88fb5-b024-4361-ba79-63cdfc5e67cb)
![image-55](https://github.com/user-attachments/assets/43b96a06-d27c-46bf-b24a-1c0d7196f55a)
![image-56](https://github.com/user-attachments/assets/bb944f60-0378-436b-b76e-f344a0c2a584)


- Don't forget to update the container registroty name in the script file.
![image-23](https://github.com/user-attachments/assets/f74f2934-17d8-477a-a964-b725ab67e672)



Now, try to get all resouces and you will noticed there is an error related to "ImagePullBackoff".

```sh
kubectl get all
```
I am getting below error message.
![image-58](https://github.com/user-attachments/assets/71922859-a009-45c5-b89c-433f30c06ac1)


**Solution**: As we are using private registory and we need to use 'imagepullsecrets'

Go to azure registory and get the password which will be used in below command
![image-60](https://github.com/user-attachments/assets/5549858c-2c3e-493d-a802-c881af820477)


- command to create ```ACRImagePullSecret```
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
kubectl delete secret acr-credential --namespace default
 ``` 

Also, update the manifest file as below.
![image-64](https://github.com/user-attachments/assets/d861db86-e257-469e-8e71-9724640893a0)



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
kubectl describe svc argocd-server -n argocd
```

- Now, we will open one more port in VMSS
![image-66](https://github.com/user-attachments/assets/45f7d9a5-7045-40d5-b305-d293de571cd8)
![image-58](https://github.com/user-attachments/assets/948cd77a-6f01-4d01-ba4a-ff98acea791d)


```sh

azureuser@devopsdemovm:~$ kubectl get all

NAME                                    READY   STATUS    RESTARTS   AGE
pod/santa-deployment-786c6cb64d-6jrf6   1/1     Running   0          8m50s
pod/santa-deployment-786c6cb64d-sgtgp   1/1     Running   0          8m50s

NAME                 TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
service/kubernetes   ClusterIP      10.0.0.1       <none>        443/TCP          155m
service/santa-ssvc   LoadBalancer   10.0.191.143   <pending>     8080:32144/TCP   8m51s

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/santa-deployment   2/2     2            2           8m51s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/santa-deployment-786c6cb64d   2         2         2       8m51s

 kubectl get nodes -o wide
NAME                             STATUS   ROLES    AGE    VERSION   INTERNAL-IP   EXTERNAL-IP     OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
aks-system-36575698-vmss000000   Ready    <none>   155m   v1.31.2   10.224.0.4    52.191.142.89   Ubuntu 22.04.5 LTS   5.15.0-1075-azure   containerd://1.7.23-1

```
from Agent VM:
![image-55](https://github.com/user-attachments/assets/fed57ab7-6e27-41d4-ae23-f27c5a3ad404)

Congratulations :-) the application is working and accessible.
![image-59](https://github.com/user-attachments/assets/1696388a-4533-4a1f-a614-4e4c6d668092)
![image-60](https://github.com/user-attachments/assets/4037017c-8d07-495e-ab64-b67ec6efc3e8)
![image-61](https://github.com/user-attachments/assets/5257cb03-5e34-4e44-ad1f-afa06332afb1)
![image-62](https://github.com/user-attachments/assets/72ee4948-479d-48e6-8840-9a02bcb66066)




#### <span style="color: yellow;"> Step-05: Cleanup the images and container registroy using the pipeline.</span>

- First create [Service Connection](https://www.youtube.com/watch?v=pSmKNbN_Y4s) in Azure Devops.
- Once you create a connection then note it down the connection ID, because that ID would be used in pipeline. 
- On agent machine, make sure login with azure login and connection is active, if not then login with following.
  ```sh
  az login --use-device-code
  ```
    
## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete 

- __Delete all deployment/Service__ first
     
      kubectl delete deployment.apps/santa-deployment
      kubectl delete service/santa-ssvc
      
 
#### Now, time to delete the ```AKS Cluster and Virtual machine```.
run the terraform command.
```bash
Terraform destroy --auto-approve
```

## <span style="color: Yellow;"> Conclusion

The Secret Santa Generator web application is a comprehensive project that showcases various aspects of Spring development, database management, and web application architecture. It provides a practical solution to a common problem while offering valuable learning opportunities for developers.


__Ref Link:__

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

