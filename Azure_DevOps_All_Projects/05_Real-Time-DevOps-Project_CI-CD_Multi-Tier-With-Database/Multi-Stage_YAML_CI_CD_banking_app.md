# <span style="color: Yellow;"> Azure DevOps Multi-Stage YAML CI/CD Pipeline </span>

This document provides a step-by-step guide on setting up a multi-stage YAML CI/CD pipeline in Azure DevOps. The pipeline includes setting up an Azure account, creating an organization, setting up a project, writing a YAML pipeline, and deploying an application to an AKS cluster.

## <span style="color: Yellow;"> Prerequisites </span>

Before diving into this project, here are some skills and tools you should be familiar with:

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/02_Real-Time-DevOps-Project_CR_AKS_with-EC2)<br>
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
-a---l          26/12/24   9:29 PM           6571 EC2.tf
-a---l          26/12/24   9:29 PM            892 main.tf
-a---l          26/12/24   9:29 PM            567 output.tf
-a---l          27/12/24   4:00 PM          26624 Project_Voting Apps.md
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


## Steps



new project:
![alt text](image-4.png)
![alt text](image-5.png)
![alt text](image-6.png)


Git clone: https://github.com/jaiswaladi246/Multi-Tier-With-Database
![alt text](image-7.png)

  - Need to configure Self-hosted Linux agents/[integrate](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/linux-agent?view=azure-devops) to azure DevOps


select the project and project setting:
![alt text](image-24.png)

![image-12](https://github.com/user-attachments/assets/27299cbd-4588-4cec-ae89-70667015d8b2)
![image-13](https://github.com/user-attachments/assets/2b19c543-db44-4736-ad93-43a8e30544af)
![image-14](https://github.com/user-attachments/assets/0d24cff6-99bc-4055-acf0-8eaeb14539bd)

Select the agent pools name, you can choose any name 
- devops-demo_vm 
![image-15](https://github.com/user-attachments/assets/23084fd1-3dfd-415c-8a81-9aa264690c0a)
![image-16](https://github.com/user-attachments/assets/fdf5d367-ba38-4261-bd09-56284907f384)

run the following command as part of provision the server, we have already install the agent.
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

- **Need to create a PAT access Token-** 
  - Go to azure devops user setting and click on PAT.

![image-17](https://github.com/user-attachments/assets/bcba6e48-3cec-4f3b-89d1-8b2b8fdd9d21)
![image-18](https://github.com/user-attachments/assets/597e4b8d-8fc9-4b51-a7c7-6d276d82be62)
![image-19](https://github.com/user-attachments/assets/3f298f04-4bc1-4cc1-98a4-a11573369257)

- Give any name for agent
```sh
devops-demo_vm
```
![image-20](https://github.com/user-attachments/assets/4a52c9b4-60e4-4c1b-b5a7-227786e0b3b0)

Agent is still offline.
![image-21](https://github.com/user-attachments/assets/d2d4ef96-53cb-41cf-959e-e3229c47544d)

- We have to Optionally run the agent interactively. If you didn't run as a service above:
```powershell
~/myagent$ ./run.sh &
```
Now, Agent is online ;-)

![image-22](https://github.com/user-attachments/assets/72bf3b1f-db9e-4ebc-b7c7-0008a7f477ba)


![alt text](image-25.png)
![alt text](image-26.png)
![alt text](image-27.png)
![alt text](image-28.png)
![alt text](image-29.png)

- Install SonarQube Extension.

Now, we will integrate SonarQube in same pipeline.
we have to search it in market place and select the sonarqube as below.
![alt text](image-38.png)
![alt text](image-39.png)
![alt text](image-40.png)

Select the organization
![alt text](image-41.png)
![alt text](image-42.png)

- Sonar Setup:
  - <publicIPaddressofVM:9000>
  
![alt text](image.png)
![alt text](image-1.png)
![alt text](image-2.png)
![alt text](image-3.png)

- Generate the SonarQubeToken-
![alt text](image-48.png)
![alt text](image-49.png)



- Will create a [service principle](https://www.youtube.com/watch?v=CUHtHGS4xEc&list=PLJcpyd04zn7rxl0X8mBdysb5NjUGIsJ7W&index=3).

Take putty session of Agent VM and do the following
```sh
az login --use-device-code
```
![alt text](image-84.png)

```sh
az ad sp <name_of_SP> --role="contributor" --scope="subscriptions/SUBSCRIPTION_ID"
```
![alt text](image-85.png)


- Configure the Service Connection for "```Azure Resource Manager```"
- Steps to configure connection for [Azure Resource Manager](https://learn.microsoft.com/en-us/azure/devops/pipelines/release/configure-workload-identity?view=azure-devops&tabs=managed-identity):


![alt text](image-17.png)
![alt text](image-86.png)
![alt text](image-87.png)









- Select the project and project setting:
  

Will create connection as below
   
    - 01. SonarQube
    - 02. Docker registory
    - 03. AKS Cluster
    

- Steps to configure connection for SonarQube:

![alt text](image-9.png)
![alt text](image-10.png)

- Steps to configure connection for Dockerregistory:
![alt text](image-11.png)
![alt text](image-12.png)

- Steps to configure connection for Kubernetes:

![alt text](image-13.png)

 It will popup for login crednetial and it should be used the same cred which you have used for UI portal login.

 ![alt text](image-14.png)








- Click on pipeline and build it 
![alt text](image-15.png)
![alt text](image-16.png)
![alt text](image-8.png)
![alt text](image-18.png)


- Configure the Maven (Package)
![alt text](image-34.png)
![alt text](image-44.png)


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

- Configure the Maven (Test)
![alt text](image-45.png)
![alt text](image-46.png)

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
![alt text](image-50.png)


- Add Stages for Trivy
![alt text](image-47.png)

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

- Add Stages for SonarQube
- taking help from helper as below to complete the stage for sonarqube
![alt text](image-19.png)
![alt text](image-20.png)
![alt text](image-21.png)
![alt text](image-22.png)

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
![alt text](image-54.png)

- Status in SonarQube for analysis.
![alt text](image-53.png)


- Add build package stage and publish artifacts into ```Azure artifacts```.
![alt text](image-55.png)
![alt text](image-57.png)
click on setting and change the permission as below.
![alt text](image-58.png)
![alt text](image-59.png)


build the project and then add maven Authentication
![alt text](image-62.png)
![alt text](image-63.png)

![alt text](image-60.png)
![alt text](image-61.png)

```sh
# To Publish the Artifacts.
  - stage: Publish_Artifact
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

next step would be, click the ```artifacts```
![alt text](image-23.png)
![alt text](image-64.png)
![alt text](image-65.png)

Run the pipeline and status of pipeline as below-

I am getting below error message.
![alt text](image-69.png)

**Solution:** 
- Add the repo to both your pom.xml's ```repositories``` and ```distributionManagement``` sections.

![alt text](image-66.png)
replace with below and commit it.
![alt text](image-67.png)
![alt text](image-68.png)


ReRun the pipeline and status of pipeline as below-
![alt text](image-30.png)

Validate the artifacts:
![alt text](image-31.png)
![alt text](image-32.png)



- Add Stage for ```Docker build image```
![alt text](image-70.png)


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

- Add Stage for ```Trivy Image scan```

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


- Add Stage for ```Docker Push Image```
  
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

- Add Stage for ```Deploy on AKS```
![alt text](image-71.png)
![alt text](image-72.png)

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


Pipeline status
![alt text](image-35.png)
![alt text](image-36.png)




Will try to access the site:
select the pipeline and edit and add the below two.






### Setup AKS Cluster


- update the image name in manifest file.
![alt text](image-37.png)


pipeline status


View status in Azure UI:from UI | K8s
![alt text](image-51.png)
![alt text](image-52.png)
![alt text](image-43.png)
![alt text](image-73.png)


az login
![alt text](image-56.png)




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
from Agent VM:



Open port in k8s vmss
![alt text](image-74.png)




application works :-)

![alt text](image-75.png)
![alt text](image-76.png)
![alt text](image-77.png)
![alt text](image-78.png)
![alt text](image-79.png)





```sh
azureuser@devopsdemovm:~$ docker --version
Docker version 27.4.1, build b9d17ea
azureuser@devopsdemovm:~$ docker images ls
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE

No images found matching "ls": did you mean "docker image ls"?
azureuser@devopsdemovm:~$ docker image ls
REPOSITORY                                       TAG       IMAGE ID       CREATED       SIZE
mc1arke/sonarqube-with-community-branch-plugin   latest    307499b84ff2   13 days ago   1.13GB
azureuser@devopsdemovm:~$ docker container ls
CONTAINER ID   IMAGE                                            COMMAND                  CREATED          STATUS          PORTS                                       NAMES
973939f2cdc7   mc1arke/sonarqube-with-community-branch-plugin   "/opt/sonarqube/dock…"   41 minutes ago   Up 41 minutes   0.0.0.0:9000->9000/tcp, :::9000->9000/tcp   sonar
azureuser@devopsdemovm:~$ java --version
openjdk 17.0.13 2024-10-15
OpenJDK Runtime Environment (build 17.0.13+11-Ubuntu-2ubuntu122.04)
OpenJDK 64-Bit Server VM (build 17.0.13+11-Ubuntu-2ubuntu122.04, mixed mode, sharing)
azureuser@devopsdemovm:~$ trivy --version
Version: 0.58.1
azureuser@devopsdemovm:~$ az version
{
  "azure-cli": "2.67.0",
  "azure-cli-core": "2.67.0",
  "azure-cli-telemetry": "1.1.0",
  "extensions": {}
}
azureuser@devopsdemovm:~$ mvn -version
Apache Maven 3.6.3
Maven home: /usr/share/maven
Java version: 17.0.13, vendor: Ubuntu, runtime: /usr/lib/jvm/java-17-openjdk-amd64
Default locale: en, platform encoding: UTF-8
OS name: "linux", version: "6.5.0-1025-azure", arch: "amd64", family: "unix"
azureuser@devopsdemovm:~$
```










































***********************************



- #### <span style="color: Yellow;">**Step-01: Create project in Azure DevOps**
  - Open the Azure UI and DevOps portal ```https://dev.azure.com/<name>```
  - Create a new project
    - URL: https://github.com/mrbalraj007/k8s-kind-voting-app.git
    - Original Repo; https://github.com/dockersamples/example-voting-app

- #### <span style="color: Yellow;">**Step-02: Clone the Repo in Azure DevOps**
  - Clone the repo :: 
    - click on Imort a repository
![image](https://github.com/user-attachments/assets/4a94ca68-f0b0-42ab-942c-b0931693185c)
![image-1](https://github.com/user-attachments/assets/41ef28b8-8ebd-4fd7-b86e-87f669f3af5f)
![image-82](https://github.com/user-attachments/assets/ee378853-8a1c-455b-a290-574a6a4538c1)

- #### <span style="color: Yellow;"> Create/Configure a pipeline in Azure DevOps.
  - Click on Pipeline:
   - follow the below instruction
    ![image-2](https://github.com/user-attachments/assets/2575c03f-2af8-4c35-96b8-ba468686981b)
    ![image-3](https://github.com/user-attachments/assets/d002d185-8804-4c3d-9f34-f5f41d6cfed3)
    ![image-4](https://github.com/user-attachments/assets/a053a4e2-3548-4ff0-8b0c-d2c37f164540)
    ![image-5](https://github.com/user-attachments/assets/335a497b-2960-4a9a-bf8c-85ea56d35840)
    ![image-6](https://github.com/user-attachments/assets/36ebae46-e1db-4959-820b-f54d8a455550)
it will asking you to login with you azure login. please use the same login crednetial which you have configure for azure portal login.

Select the container registry
![image-7](https://github.com/user-attachments/assets/ebc5630e-d798-45d5-8688-2fe602defb3c)


- **Note:** Key concept overview of pipeline.
![image-9](https://github.com/user-attachments/assets/2c902e33-4243-4171-a666-9d0eb5743120)

you will see the following pipeline yaml and we have to modify accordingly.
![image-8](https://github.com/user-attachments/assets/ab975781-a81a-41b7-bc2c-fa0686ac518b)

- We have to update the CI_pipeline as below
  - [Vote_pipeline](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/02_Real-Time-DevOps-Project_CR_AKS_with-EC2/PipeLine_Details/CI-CD/Updated_vote_pipeline.md)
  - [result_pipeline](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/02_Real-Time-DevOps-Project_CR_AKS_with-EC2/PipeLine_Details/CI-CD/Updated_Results_pipeline.md)
  - [worker_pipeline](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/02_Real-Time-DevOps-Project_CR_AKS_with-EC2/PipeLine_Details/CI-CD/Updated_worker_pipeline.md)

- First we will create a folder in repo called 'scripts' and update the sh file as below. we will create a shell script to get an updated image tag in case if it is creating new image.
![image-54](https://github.com/user-attachments/assets/3ec88fb5-b024-4361-ba79-63cdfc5e67cb)
![image-55](https://github.com/user-attachments/assets/43b96a06-d27c-46bf-b24a-1c0d7196f55a)
![image-56](https://github.com/user-attachments/assets/bb944f60-0378-436b-b76e-f344a0c2a584)


- Don't forget to update the container registroty name in the script file.
![image-23](https://github.com/user-attachments/assets/f74f2934-17d8-477a-a964-b725ab67e672)

- #### <span style="color: Yellow;">**Step-03: To configure Self-hosted Linux agents in Azure DevOps**
 
  - Build the pipeline but I got below error message 
![image-10](https://github.com/user-attachments/assets/5bf94c30-9a3e-48f6-a012-781baed2c0c3)


- Rerun the pipeline and it works.
![image-68](https://github.com/user-attachments/assets/b276f705-0011-4cc6-93b1-093b002dafef)


- Rename the pipeline
![image-24](https://github.com/user-attachments/assets/5b7096a4-c010-4d89-8110-b63a1ae16e7c)
![image-25](https://github.com/user-attachments/assets/6a98f1e6-d5ad-435e-b705-73d5d84e5d6b)
![image-26](https://github.com/user-attachments/assets/3418abcc-2b73-4142-a5d6-edbf879a83f6)
![image-27](https://github.com/user-attachments/assets/5b3e2bc1-d0b2-4a65-9296-97335e901634)



- Will create two more pipeline (microservices).
  - result
  - worker 
  ![image-28](https://github.com/user-attachments/assets/538f3fcf-4d00-42c3-8712-e4b0e159558e)

- Repository status in Container Registry.  
![image-29](https://github.com/user-attachments/assets/928cba0b-bc7c-4e9d-997a-3b93e27813cf)


#### <span style="color: Yellow;">**Step-04: Setup ArgoCD**</span>

  - K8s Cluster login
  - Argocd install
  - Configure Argocd 

- Go Azure UI and select the AKS cluster 
![image-69](https://github.com/user-attachments/assets/72890d18-4698-4d12-864b-b61e493b02d1)
![image-70](https://github.com/user-attachments/assets/6b1ce124-10dc-4384-a370-add50bf1cce0)
![image-71](https://github.com/user-attachments/assets/61df9213-b7fc-4fbd-9e2b-dca92839e776)


Take putty session of Azure VM and perform the following instruction to login into auzre and K8s

- **Azure login**:

Missing Browser on Headless Servers, Use the --use-device-code flag to authenticate without a browser:
```
az login --use-device-code
```
![image-30](https://github.com/user-attachments/assets/c091888a-bcb3-4bfd-a726-aa4466225ff4)

- https://microsoft.com/devicelogin access this URL in a new browser and type the code which you see in console.
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

#### <span style="color: orange;"> Install ArgoCD
```sh
kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

#### <span style="color: orange;"> Configure ArgoCD </span>

- Run the following commands to verify the ```Pods``` and ```services type```

```sh
kubectl get pods -n argocd
kubectl get svc -n argocd
```

- To get details of Pods in namespace "argocd"
```sh
kubectl get pods -n argocd
```
![image-37](https://github.com/user-attachments/assets/adbaba7c-bee9-44a9-a967-4dd352830ad2)

- To get the secrets for argoCd
```sh
kubectl get secrets -n argocd
```
![image-38](https://github.com/user-attachments/assets/be9e563f-b8bd-4ec6-8bc3-b1b3c1a13900)

- To get service details in argocd
```sh
kubectl get svc -n argocd
```
```sh
azureuser@devopsdemovm:~/myagent$ kubectl get svc -n argocd
NAME                                      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
argocd-applicationset-controller          ClusterIP   10.0.199.83    <none>        7000/TCP,8080/TCP            6m17s
argocd-dex-server                         ClusterIP   10.0.236.32    <none>        5556/TCP,5557/TCP,5558/TCP   6m17s
argocd-metrics                            ClusterIP   10.0.231.144   <none>        8082/TCP                     6m17s
argocd-notifications-controller-metrics   ClusterIP   10.0.54.255    <none>        9001/TCP                     6m16s
argocd-redis                              ClusterIP   10.0.38.40     <none>        6379/TCP                     6m16s
argocd-repo-server                        ClusterIP   10.0.29.153    <none>        8081/TCP,8084/TCP            6m16s
argocd-server                             ClusterIP   10.0.216.42    <none>        80/TCP,443/TCP               6m16s
argocd-server-metrics                     ClusterIP   10.0.201.27    <none>        8083/TCP                     6m16s

```
![image-40](https://github.com/user-attachments/assets/8e3a84e1-1f05-4d36-8e66-a3e48e92f2ca)

- Currently, it is set to ```clusterIP``` and we will change it to ```NodePort```
```sh
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
```
- Review the service again
```sh
kubectl get svc -n argocd

azureuser@devopsdemovm:~$ kubectl get svc -n argocd
NAME                                      TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                      AGE
argocd-applicationset-controller          ClusterIP   10.0.98.49    <none>        7000/TCP,8080/TCP            49m
argocd-dex-server                         ClusterIP   10.0.130.97   <none>        5556/TCP,5557/TCP,5558/TCP   49m
argocd-metrics                            ClusterIP   10.0.91.113   <none>        8082/TCP                     49m
argocd-notifications-controller-metrics   ClusterIP   10.0.83.161   <none>        9001/TCP                     49m
argocd-redis                              ClusterIP   10.0.241.99   <none>        6379/TCP                     49m
argocd-repo-server                        ClusterIP   10.0.38.142   <none>        8081/TCP,8084/TCP            49m
argocd-server                             NodePort    10.0.228.33   <none>        80:32648/TCP,443:31181/TCP   49m
argocd-server-metrics                     ClusterIP   10.0.124.90   <none>        8083/TCP                     49m
```
![image-41](https://github.com/user-attachments/assets/b76f53f9-6319-42a0-995e-157c1a388957)

- To get URL/IP address details
```sh
kubectl get nodes -o wide
```
```sh
azureuser@devopsdemovm:~/myagent$ kubectl get nodes -o wide
NAME                                STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
aks-agentpool-23873620-vmss000000   Ready    <none>   54m   v1.30.6   10.224.0.4    <none>        Ubuntu 22.04.5 LTS   5.15.0-1075-azure   containerd://1.7.23-1
```
![image-42](https://github.com/user-attachments/assets/8343415e-3b3f-4707-9cef-c0f31b2722cd)

<!-- - Currently, it is set to ```NodePort``` and we will change it to ```LoadBalancer```
- Expose Argo CD server using NodePort:
```sh
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
``` -->

**Verify Kubernetes Config:** Confirm that the argocd-server service has the correct ```NodePort``` and is not misconfigured:

```bash
kubectl describe svc argocd-server -n argocd
```
```sh
azureuser@devopsdemovm:~$ kubectl get secrets -n argocd
NAME                          TYPE     DATA   AGE
argocd-notifications-secret   Opaque   0      8s
argocd-secret                 Opaque   0      8s
azureuser@devopsdemovm:~$ kubectl get svc -n argocd
NAME                                      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
argocd-applicationset-controller          ClusterIP   10.0.131.57    <none>        7000/TCP,8080/TCP            16s
argocd-dex-server                         ClusterIP   10.0.17.67     <none>        5556/TCP,5557/TCP,5558/TCP   16s
argocd-metrics                            ClusterIP   10.0.192.242   <none>        8082/TCP                     16s
argocd-notifications-controller-metrics   ClusterIP   10.0.157.137   <none>        9001/TCP                     16s
argocd-redis                              ClusterIP   10.0.213.183   <none>        6379/TCP                     16s
argocd-repo-server                        ClusterIP   10.0.159.107   <none>        8081/TCP,8084/TCP            16s
argocd-server                             ClusterIP   10.0.91.83     <none>        80/TCP,443/TCP               16s
argocd-server-metrics                     ClusterIP   10.0.140.102   <none>        8083/TCP                     16s
azureuser@devopsdemovm:~$ kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
service/argocd-server patched
azureuser@devopsdemovm:~$ kubectl get svc -n argocd
NAME                                      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
argocd-applicationset-controller          ClusterIP   10.0.131.57    <none>        7000/TCP,8080/TCP            34s
argocd-dex-server                         ClusterIP   10.0.17.67     <none>        5556/TCP,5557/TCP,5558/TCP   34s
argocd-metrics                            ClusterIP   10.0.192.242   <none>        8082/TCP                     34s
argocd-notifications-controller-metrics   ClusterIP   10.0.157.137   <none>        9001/TCP                     34s
argocd-redis                              ClusterIP   10.0.213.183   <none>        6379/TCP                     34s
argocd-repo-server                        ClusterIP   10.0.159.107   <none>        8081/TCP,8084/TCP            34s
argocd-server                             NodePort    10.0.91.83     <none>        80:32603/TCP,443:31657/TCP   34s
argocd-server-metrics                     ClusterIP   10.0.140.102   <none>        8083/TCP                     34s
azureuser@devopsdemovm:~$ kubectl get nodes -o wide
NAME                             STATUS   ROLES    AGE     VERSION   INTERNAL-IP   EXTERNAL-IP      OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
aks-system-18075837-vmss000000   Ready    <none>   6h12m   v1.31.2   10.224.0.4    52.183.119.235   Ubuntu 22.04.5 LTS   5.15.0-1075-azure   containerd://1.7.23-1
azureuser@devopsdemovm:~$ kubectl describe svc argocd-server -n argocd
Name:                     argocd-server
Namespace:                argocd
Labels:                   app.kubernetes.io/component=server
                          app.kubernetes.io/name=argocd-server
                          app.kubernetes.io/part-of=argocd
Annotations:              <none>
Selector:                 app.kubernetes.io/name=argocd-server
Type:                     NodePort
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.0.91.83
IPs:                      10.0.91.83
Port:                     http  80/TCP
TargetPort:               8080/TCP
NodePort:                 http  32603/TCP
Endpoints:                10.244.0.25:8080
Port:                     https  443/TCP
TargetPort:               8080/TCP
NodePort:                 https  31657/TCP
Endpoints:                10.244.0.25:8080
Session Affinity:         None
External Traffic Policy:  Cluster
Internal Traffic Policy:  Cluster
Events:                   <none>
azureuser@devopsdemovm:~$

```
Then access it at ```http://52.148.171.58:32648```.

If page is not opening then we have to open a port in NSG.
- On Azure portal server with ```VMSS``` and select the ```VMSS```
![image-72](https://github.com/user-attachments/assets/65c78f84-d41f-4401-a73b-b70e3530bcc1)
![image-74](https://github.com/user-attachments/assets/90c6f4d2-f589-471c-a4cf-bdbdff3d187c)
![image-75](https://github.com/user-attachments/assets/28bee629-0166-48ef-a12e-bf2f12ce355e)
![image-76](https://github.com/user-attachments/assets/9b33b1a7-4012-45b4-b2d6-a66f655b66a6)
![image-77](https://github.com/user-attachments/assets/20bf8d81-a170-4469-83af-16e9a1412515)


Now, we need to try to access it again ```http://PublicIPAddress:32648```.
![image-78](https://github.com/user-attachments/assets/cc35a59c-1c79-437b-8cad-95962fae81f5)

- To retrive the password for argocd
```sh
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
![image-39](https://github.com/user-attachments/assets/eb10d8f6-a3f2-462d-8e39-7e6750f98684)

- <span style="color: orange;"> To configure repo in argocd with token base.
```sh
(http://PublicIPAddress:32603)
```
![image-44](https://github.com/user-attachments/assets/67a669ed-58f8-4cb0-9c76-ef8c8db18451)

Go to azure pipeline and clink on setting and select "Personal Access Token"
![image-45](https://github.com/user-attachments/assets/c449ee33-2507-4a64-8989-a230e78107fa)
![image-46](https://github.com/user-attachments/assets/ed562b32-9ef8-4a17-902f-7f698dab0dfe)
![image-47](https://github.com/user-attachments/assets/a99cccd6-b5a1-4e40-a011-f903df1ab914)
![alt text](image-82.png)

```sh
https://<Accesstoken>@dev.azure.com/mrbalraj/balraj-devops/_git/balraj-devops
```
![image-49](https://github.com/user-attachments/assets/45d23906-d3cf-4b13-919c-1760b3732032)


- <span style="color: orange;"> To create a application in argocd
  Once you access the ArgoCD URL and create an application
  - **Application Name**: voteaccess-service
  - **Project Name**: default
  - **Sync Policy**: Automatic (Select Prune Resources and SelfHeal)
  - **Repository URL**: https://mrbalraj@dev.azure.com/mrbalraj/Multi-Tier-With-Database/_git/Multi-Tier-With-Database
  - **Revison**: main
  - **Path**:  k8s-specifications (where Kubernetes files reside)
  - **cluster URL**: Select default cluster
  - **Namespace**: default

![image-50](https://github.com/user-attachments/assets/86145803-8e75-49ef-ad28-b4c5874cb586)
![image-51](https://github.com/user-attachments/assets/ea3b2881-3eb6-4976-84ff-e6474f090242)


by default 3 min to sync with argocd but it can be changed as below.

![image-52](https://github.com/user-attachments/assets/bf5b1d61-3308-41ec-a10c-0f9d737ffefb)
![image-53](https://github.com/user-attachments/assets/ab5194c9-7b83-4e70-82ff-457027a3ba8c)



- Now, we will change the argocd default time (3 min) to 10 sec.

```sh
kubectl edit cm argocd-cm -n argocd
```
edit as below
![image-57](https://github.com/user-attachments/assets/4b069769-da73-4cb1-bbf9-f16c60d25dcb)

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
kubectl get secret
```

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
![alt text](image-80.png)
![alt text](image-81.png)


here is the updated service status

![image-63](https://github.com/user-attachments/assets/ba027da4-d678-4bc4-a219-3694510939ab)


Try to update anything at vote folder in ```"dockerfile"``` as below and pipeline should be auto triggered.
![alt text](image-83.png)

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

# Verify node resources (CPU, memory) are sufficient to run the application
kubectl describe node aks-system-18075837-vmss000000
```

- Now, we will open one more port in VMSS
![image-66](https://github.com/user-attachments/assets/45f7d9a5-7045-40d5-b305-d293de571cd8)

```sh
kubectl describe node aks-system-18075837-vmss000000
```
- Application is accessible now.
xx


Congratulations :-) the application is working and accessible.


#### <span style="color: yellow;"> Step-05: Cleanup the images and container registroy using the pipeline.</span>

- First create [Service Connection](https://www.youtube.com/watch?v=pSmKNbN_Y4s) in Azure Devops.
- Once you create a connection then note it down the connection ID, because that ID would be used in pipeline. 
- On agent machine, make sure login with azure login and connection is active, if not then login with following.
  ```sh
  az login --use-device-code
  ```
- Delete all the images along with repogitory.
    - Delete all images from [result-app](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/02_Real-Time-DevOps-Project_CR_AKS_with-EC2/PipeLine_Details/Delete_Images_Repositories/Updated_Delete_Results_pipeline.md)
    - Delete all images from [vote-app](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/02_Real-Time-DevOps-Project_CR_AKS_with-EC2/PipeLine_Details/Delete_Images_Repositories/Updated_Delete_vote_pipeline.md)
    - Delete all images from [worker-app](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/02_Real-Time-DevOps-Project_CR_AKS_with-EC2/PipeLine_Details/Delete_Images_Repositories/Updated_Delete_worker_pipeline.md)

## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete 

- __Delete all deployment/Service__ first
     ```sh
        kubectl delete service/redis
        kubectl delete service/db
        kubectl delete service/resut
        kubectl delete service/result
        kubectl delete service/vote
        kubectl delete deployment.apps/db
        kubectl delete deployment.apps/redis
        kubectl delete deployment.apps/vote
        kubectl delete deployment.apps/worker
        kubectl delete deployment.apps/db
        kubectl delete deployment.apps/result
        kubectl delete service/db
        
![image-67](https://github.com/user-attachments/assets/b63fbef2-5720-4143-9cd3-c04d836f4cd3)

#### Now, time to delete the ```AKS Cluster and Virtual machine```.
run the terraform command.
```bash
Terraform destroy --auto-approve
```

## <span style="color: Yellow;"> Conclusion

Following these steps, you can set up a complete CI/CD pipeline in Azure DevOps, from setting up the infrastructure to deploying an application to an AKS cluster.


__Ref Link:__

## Additional Resources
- [Azure DevOps Documentation](https://docs.microsoft.com/en-us/azure/devops/)
- [Azure Kubernetes Service Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [SonarQube Documentation](https://docs.sonarqube.org/latest/)
- [Trivy Documentation](https://github.com/aquasecurity/trivy)


- [CI-Pipeline](https://www.youtube.com/watch?v=aAjH9wqtx9o&list=PLdpzxOOAlwvIcxgCUyBHVOcWs0Krjx9xR&index=15)

- [CD-Pipeline](https://www.youtube.com/watch?v=HyTIsLZWkZg&list=PLdpzxOOAlwvIcxgCUyBHVOcWs0Krjx9xR&index=16)
  
- [pipelines troubleshooting](https://learn.microsoft.com/en-us/azure/devops/pipelines/troubleshooting/troubleshooting?view=azure-devops)

- [Create an Account in Azure DevOps](https://www.youtube.com/watch?v=A91difri0BQ)

- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

- [Install AWS Cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

- [kubernetes-deploy-terraform?pivots=development-environment-azure-cli](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-terraform?pivots=development-environment-azure-cli)

- [AKS Cluster](https://developer.hashicorp.com/terraform/tutorials/kubernetes/aks)

- [create-aks-cluster-using-terraform](https://stacksimplify.com/azure-aks/create-aks-cluster-using-terraform/)

- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/operator-manual/upgrading/2.0-2.1/#replacing-app-resync-flag-with-timeoutreconciliation-setting)

- [ArgoCD Version](https://argo-cd.readthedocs.io/en/stable/)

- [Pull Registory](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)

- [What is Azure Pipelines?](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops)

- [YAML vs Classic Pipelines (Two type of Azure Devops pipeline)](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/pipelines-get-started?view=azure-devops) 

https://github.com/mc1arke/sonarqube-community-branch-plugin?tab=readme-ov-file
https://hub.docker.com/r/mc1arke/sonarqube-with-community-branch-plugin

- [Connect to Azure with an Azure Resource Manager service connection](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-using-workload-identity-federation)