# Implementing CI/CD with Azure DevOps: Azure Artifacts and Release Pipelines

## Overview
This project provides a comprehensive guide to implementing Continuous Integration and Continuous Deployment (CI/CD) using Azure DevOps with a focus on Azure Artifacts and Release Pipelines. The project uses a Nike landing page as a practical example to demonstrate the concepts and steps involved.

### Key Points
1. **Introduction to Azure Artifacts**:
   - Overview of Azure Artifacts and their importance in CI/CD.
   - Comparison with other central package management repositories like Nexus and JFrog Artifactory.

2. **Setting Up the Infrastructure**:
   - Steps to set up the Azure DevOps project and Azure Web App.
   - Creating an Azure Artifact feed to host the package.

3. **Creating CI Pipeline**:
   - Writing a YAML pipeline to build the package and push it to the Azure Artifact feed.
   - Customizing npm install and build commands for the Tailwind CSS project.

4. **Creating Release Pipeline**:
   - Steps to create a release pipeline that consumes the package from the Azure Artifact feed.
   - Configuring deployment triggers and post-deployment steps.

5. **Promoting Packages and Upstream Sources**:
   - Promoting packages between different views (local, pre-release, release).
   - Using upstream sources to download dependencies from supported registries.

### Advantages of Using This Project
- **Centralized Package Management**: Azure Artifacts provide a central repository for storing and managing packages, ensuring better control and auditability.
- **Automated Deployment**: The project demonstrates how to automate the deployment process using Azure DevOps release pipelines.
- **Enhanced Flexibility**: Promoting packages between different views allows for better control over the deployment process.
- **Scalability**: Using Azure Web App allows for easy scaling of the application based on demand.

### Impact of Using This Project
- **Improved Efficiency**: Automating the build and deployment process saves time and reduces the risk of human error.
- **Increased Reliability**: Ensuring that only tested and approved packages are deployed to production increases the reliability of the application.
- **Faster Time-to-Market**: Continuous deployment enables faster release cycles, allowing new features and updates to reach users more quickly.
- **Better User Experience**: Reduced downtime during deployments ensures a better user experience, as the application remains available during updates.

### Conclusion
This project provides a detailed guide to implementing CI/CD using Azure DevOps with a focus on Azure Artifacts and Release Pipelines. By following the steps outlined, users can achieve better control, efficiency, and reliability in their build and deployment processes. The use of Azure Artifacts ensures centralized package management, while the release pipelines automate the deployment process, enhancing the overall user experience. This project serves as a valuable resource for anyone looking to implement DevOps practices in their workflow.
across different environments.

## <span style="color: Yellow;"> Prerequisites </span>

Before diving into this project, here are some skills and tools you should be familiar with:

Need to create a PAT access Token-

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/02_Real-Time-DevOps-Project_CR_AKS_with-EC2)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
    - Update ```terraform.tfvars```.
 
- [x] [App Repo (Example Voting App)](https://github.com/mrbalraj007/k8s-kind-voting-app.git)

- [x] __Azure Account__: You’ll need an Azure account to create resources like virtual Machine, AKS cluster, and manage pipelines.
- [x] __Terraform Knowledge__: Familiarity with Terraform to provision, manage, and clean up infrastructure.
- [x] __GitHub__: Experience with GitHub for version control and managing repositories.
- [x] __Command-Line Tools__: Basic comfort with using the command line for managing infrastructure and services.
- [x] __Basic CI/CD Knowledge__: Some understanding of Continuous Integration and Deployment is recommended.
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

![image-11](https://github.com/user-attachments/assets/26106870-9ea0-4364-94b9-5370bf1ebe30)

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


- **Need to create a PAT access Token-** 
  - Go to azure devops user setting and click on PAT.

![image-17](https://github.com/user-attachments/assets/bcba6e48-3cec-4f3b-89d1-8b2b8fdd9d21)
![image-18](https://github.com/user-attachments/assets/597e4b8d-8fc9-4b51-a7c7-6d276d82be62)
![image-19](https://github.com/user-attachments/assets/3f298f04-4bc1-4cc1-98a4-a11573369257)




Verify the project and agent pool status in DevOps Portal:

select the project and project setting:
![image-24](https://github.com/user-attachments/assets/4099693b-e859-492e-9c0e-689d862ce085)

- Select the Organization> Organization setting> Pipeline> Agent Pools
![image-4](https://github.com/user-attachments/assets/caf63f45-9fba-428e-9252-fc1f3f4145c7)

- Select the Organization> verify project is created or not.
  ![image-1](https://github.com/user-attachments/assets/efff2b28-1135-4a8f-a50a-a1f007802016)

- select the project and verify repo is imported or not.
![image-2](https://github.com/user-attachments/assets/371702e0-77d6-43a2-909b-d5571f214ab9)

Git clone: https://github.com/piyushsachdeva/nike_landing_page.git

- Verify the agent pool in project.
  - project settings> Pipelines>Agent Pools>
  - Verified that pool is not visible while it is available at organization level
    ![image-3](https://github.com/user-attachments/assets/a76eaf0e-db36-4c9e-a3f9-0dadef9bb9c4)

- add agent pool in project
- click on add pool > choose "existing" and select the pool name which is available at oraganization level.
![image-5](https://github.com/user-attachments/assets/a099c1d4-f3c9-4452-97dc-a3cf1723bffc)

- click on pool name and click on `agents`
- now, take putty session of the VM and run the following commands.
- run the following command as part of provision the server, we have already install the agent.

- **Steps to Configure the Agent for Project Context:**
  - Log in to the Azure DevOps portal.
  - Agent Pool is already create at the Project Level:
  - Navigate to your organization (https://dev.azure.com/<Organization_name>).
  - Open the Nike-Website project.
  - Go to Project Settings > Agent Pools.
  - Create a new agent pool and use an existing one.

  
- Need to configure Self-hosted Linux agents/[integrate](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/linux-agent?view=azure-devops) to azure DevOps


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


Update the ./config.sh Command: Use the --project flag to scope the agent to the Nike-Website project. The updated command would look like this:

```sh
./config.sh --url https://dev.azure.com/<OrganizationName> \
            --auth PAT \
            --token <Tocken_value> \
            --pool <nike-website-pool> \  # Pool Name
            --agent MyAgent001 \
            --project Nike-Website   # Project Name

```
Key Updates:

--project Nike-Website: Specifies the project name for scoping.
--pool nike-website-pool: Links the agent to the specific project-level pool.
Verify the Agent Registration:

After running the command, the agent should be registered in the nike-website-pool.
Go to Nike-Website > Project Settings > Agent Pools to confirm the agent is listed and active.

![image-9](https://github.com/user-attachments/assets/079fc2f7-6a30-46b0-9aa7-4f9bd480b51f)

Agent is still offline.
![image-21](https://github.com/user-attachments/assets/d2d4ef96-53cb-41cf-959e-e3229c47544d) -->

- We have to Optionally run the agent interactively. If you didn't run as a service above:
```powershell
~/myagent$ ./run.sh &
```
Now, Agent is online ;-)

![image-10](https://github.com/user-attachments/assets/abb1e69f-7d73-4921-846d-7251d480475f)


- configure Web App

 - I tried to open in browser and got below page it is because of By default azure cache is enabled and we have to disable it.
![image-14](https://github.com/user-attachments/assets/0ada3660-e71d-43cd-9e08-9d5330419eab)


  - Go to Web App and add the following settings.
![image-16](https://github.com/user-attachments/assets/d24c5b66-5239-4f45-ba44-14c6bc950515)
  ```css
  Name: WEBSITE_DYNAMIC_CACHE
  Value: 0

  Name: WEBSITE_LOCAL_CACHE_OPTION
  Value: never
  ```
![image](https://github.com/user-attachments/assets/9a2141c8-3fda-49ea-a5e1-93526287112c)

  - restart the webapp application.



- Build the pipeline.

![image-6](https://github.com/user-attachments/assets/f246b673-36e0-4c17-8ae3-c652cea614d8)
![image-7](https://github.com/user-attachments/assets/f9f77e37-406c-4b0a-b79a-e47c338ada84)
![image-8](https://github.com/user-attachments/assets/e4094acc-c9b1-46bb-a279-672499f76c59)
![image-12](https://github.com/user-attachments/assets/7b6c0503-e37b-4543-a7fe-b5b122b60b90)

# build and install npm

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

# To add the artifact.
- First need to create a feed
  - Nike-Website-First-Feed
![image-13](https://github.com/user-attachments/assets/be223b31-3e0c-4bc0-8b23-4f7efc3b2278)
![image-14](https://github.com/user-attachments/assets/9e406642-24e4-4046-84cd-97c260683b5f)

# To connect the feed
![image-15](https://github.com/user-attachments/assets/9930e5af-281e-4266-817c-1c87c7a40388)
![image-16](https://github.com/user-attachments/assets/1d849848-6705-47af-bd82-17049be319bc)

# To add the permission
![image-19](https://github.com/user-attachments/assets/ffc13f6b-be43-4c26-a9f6-e93dbee0d507)
![image-20](https://github.com/user-attachments/assets/c63950ea-e775-468e-9a09-1aa99b375476)
![image-21](https://github.com/user-attachments/assets/442b5e5d-dcbc-4157-89b8-48887ff31781)
![image-42](https://github.com/user-attachments/assets/559b6940-2cd1-46b6-83a2-facbdbbec978)

# to add stage to publish the aritifact.
![image-17](https://github.com/user-attachments/assets/712dc723-4b09-4354-b687-2700cce550e4)
![image-18](https://github.com/user-attachments/assets/132040fc-adba-4a7e-939f-a3f221b0bfd6)

```sh
- task: Npm@1
        inputs:
          command: 'publish'
          workingDir: './dist'
          publishRegistry: 'useFeed'
          publishFeed: 'c420a86b-fd1f-4e29-90eb-17d488d300b6/d00f33c5-ab18-4698-8ce1-39601d6af518'
```

- run the pipeline and it works.
![image-22](https://github.com/user-attachments/assets/33855d32-b1bd-4a41-9bde-5aeabaacb4fb)

- validate the package in artifact
![image-23](https://github.com/user-attachments/assets/02624715-7a98-42f9-a19c-d586fb1f0ca7)
![image-25](https://github.com/user-attachments/assets/5adbeacd-5a7b-4fae-9036-64c16b7e049b)


# CD pipeline.

![image-26](https://github.com/user-attachments/assets/0c921dc7-52c5-4d36-a192-c614b9b630ed)
![image-27](https://github.com/user-attachments/assets/a131f44d-a888-4714-99c9-6f921a6a4317)

Rename the stage;
![image-28](https://github.com/user-attachments/assets/ad48caaf-d4ce-444c-a605-5170dc51a79a)

# add the artifact.
![image-29](https://github.com/user-attachments/assets/78ab2e9d-eb8e-419c-bb24-e3b3932b7914)
![image-30](https://github.com/user-attachments/assets/fdb85ec1-2568-4130-83d8-d07a27aaf480)


# Enalbe the trigger
![image-31](https://github.com/user-attachments/assets/2b7692aa-0e30-4b16-b150-351d609262cf)
![image-32](https://github.com/user-attachments/assets/0f582c80-9bbf-4d6a-b9a1-d7b27568f15d)



# Configure the deployment
![image-33](https://github.com/user-attachments/assets/1f0aa631-7e8d-43ab-ba83-e076c56a68e5)

- sevice principle.

it will popup the login page and once done then select the service account which was created after Authorization.
![image-35](https://github.com/user-attachments/assets/ede13487-5391-46fc-ab4b-86f717bfb568)
![image-36](https://github.com/user-attachments/assets/d23f7789-e8f2-452e-ba63-5a5023d46f29)

Go the next step.
![image-37](https://github.com/user-attachments/assets/da2db238-4dfd-4cec-92f9-81ecb6b5de6f)
![image-38](https://github.com/user-attachments/assets/c8c9d139-77d3-4f8c-86a4-6577c6cd698e)

![image-39](https://github.com/user-attachments/assets/ddb3a8ce-0729-4663-b2c0-196e6aaa698f)
```sh
cp -rf /home/site/wwwroot/package/* /home/site/wwwroot/
```
click save.

# azure artifact (Prerelease)
![image-40](https://github.com/user-attachments/assets/343fdc4d-b2b2-48c4-9376-012f8bf21bda)
![image-41](https://github.com/user-attachments/assets/a62e002a-9034-4399-bb64-70eb09959c69)

- Release pipeline is auto trigger.


- if you face any issue then go to webapp and check the logs.
- 


xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx






























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




































https://github.com/mc1arke/sonarqube-community-branch-plugin?tab=readme-ov-file
https://hub.docker.com/r/mc1arke/sonarqube-with-community-branch-plugin


***********************************


Congratulations :-) the application is working and accessible.


#### <span style="color: yellow;"> Step-05: Cleanup the images and container registroy using the pipeline.</span>

- First create [Service Connection](https://www.youtube.com/watch?v=pSmKNbN_Y4s) in Azure Devops.
- Once you create a connection then note it down the connection ID, because that ID would be used in pipeline. 
- On agent machine, make sure login with azure login and connection is active, if not then login with following.
  ```sh
  az login --use-device-code
  ```
- Delete all the images along with repogitory.
    

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
        

#### Now, time to delete the ```AKS Cluster and Virtual machine```.
run the terraform command.
```bash
Terraform destroy --auto-approve
```

## <span style="color: Yellow;"> Conclusion




__Ref Link:__


- [Youtube Link](https://www.youtube.com/watch?v=krK4HTmaCJc&list=PLl4APkPHzsUXseJO1a03CtfRDzr2hivbD&index=8)
  
- [pipelines troubleshooting](https://learn.microsoft.com/en-us/azure/devops/pipelines/troubleshooting/troubleshooting?view=azure-devops)

- [Create an Account in Azure DevOps](https://www.youtube.com/watch?v=A91difri0BQ)

- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

- [Install AWS Cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

- [kubernetes-deploy-terraform](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-terraform?pivots=development-environment-azure-cli)

- [AKS Cluster](https://developer.hashicorp.com/terraform/tutorials/kubernetes/aks)

- [create-aks-cluster-using-terraform](https://stacksimplify.com/azure-aks/create-aks-cluster-using-terraform/)

- [Pull Registory](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)

Two type of Azure Devops pipeline
[YAML vs Classic Pipelines](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/pipelines-get-started?view=azure-devops) 

[What is Azure Pipelines?](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops)

