#  <span style="color: Yellow;">  Streamlined CI/CD Automation for a YouTube Clone Application Using Azure DevOps Classic Editor </span>

## <span style="color: Yellow;"> Key Points </span>
1. **Introduction to Azure DevOps Pipelines**:
   - Focus on Azure DevOps build and release pipelines.
   - Using a YouTube clone project for demonstration.

2. **Provisioning Azure App Service**:
   - Steps to create an Azure App Service to host the website.
   - Explanation of different options and configurations.

3. **Creating Build Pipeline**:
   - Using the classic editor to create a build pipeline.
   - Steps to configure npm install, build, and publish artifacts.

4. **Continuous Deployment**:
   - Setting up a release pipeline for continuous deployment.

## <span style="color: Yellow;"> Prerequisites </span>

Before diving into this project, here are some skills and tools you should be familiar with:

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/02_Real-Time-DevOps-Project_CR_AKS_with-EC2)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
    - Update ```terraform.tfvars```.
 
- [x] [App Repo (YouTube Clone App)](https://github.com/piyushsachdeva/Youtube_Clone)

- [x] __Azure Account__: You’ll need an Azure account to create resources like virtual Machine, AKS cluster, and manage pipelines.
- [x] __Terraform Knowledge__: Familiarity with Terraform to provision, manage, and clean up infrastructure.
- [x] __Docker Knowledge__: Basic knowledge of Docker for containerizing applications.
- [x] __GitHub__: Experience with GitHub for version control and managing repositories.
- [x] __Command-Line Tools__: Basic comfort with using the command line for managing infrastructure and services.
- [x] __Basic CI/CD Knowledge__: Some understanding of Continuous Integration and Deployment is recommended.
- [x] __Azure Container Registry (ACR)__: Set up ACR to store your Docker images.
- [x] __Linux VM__: Docker must be installed on a Linux virtual machine to run containers.

## <span style="color: Yellow;">Setting Up the Infrastructure </span>

I have created a Terraform code to set up the entire infrastructure, including the installation of required applications, tools, Storage Account and the web-site automatically created.

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

![image-69](https://github.com/user-attachments/assets/73dadfbc-e74f-43c9-847b-3882aece216a)
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

- ### <span style="color: Yellow;">**Step-01: Create project in Azure DevOps**
  - Open the Azure UI and DevOps portal ```https://dev.azure.com/<name>```
  - Create a new project
    - Git Clone: https://github.com/piyushsachdeva/Youtube_Clone
    

- ### <span style="color: Yellow;">**Step-02: Clone the Repo in Azure DevOps**
  - Clone the repo :: 
    - click on Imort a repository
![image](https://github.com/user-attachments/assets/4a94ca68-f0b0-42ab-942c-b0931693185c)
![image-68](https://github.com/user-attachments/assets/d804a0e0-8cdd-4abb-8630-6ef38884c5b6)


- ### <span style="color: Yellow;"> **Step-03: configure Self-hosted Linux agents in Azure DevOps**.
  - Need to configure Self-hosted Linux agents/[integrate](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/linux-agent?view=azure-devops) to azure DevOps

![image-70](https://github.com/user-attachments/assets/fc118368-cb74-49d3-be16-204c9144d912)
```bash
./config.sh --url https://dev.azure.com/<organization> \
            --auth PAT \
            --token <your-pat> \
            --pool <agent-pool-name> \
            --agent <agent-name>
Explanation:
--url: The URL of your Azure DevOps organization.
--auth PAT: Specifies that you are using a Personal Access Token for authentication.
--token <your-pat>: Replace <your-pat> with your actual Personal Access Token.
--pool <agent-pool-name>: Replace <agent-pool-name> with the name of the agent pool you want this agent to belong to.
--agent <agent-name>: Replace <agent-name> with the name you want to assign to this agent.
```

- We have to Optionally run the agent interactively. If you didn't run as a service above:
```powershell
~/myagent$ ./run.sh
```

![image-71](https://github.com/user-attachments/assets/bdc898eb-8816-4dfd-be14-2d45defd3b55)

![image-72](https://github.com/user-attachments/assets/132371b1-2f54-4abc-bca9-1c355953d3fd)

- Now, Agent is online ;-)
![image-73](https://github.com/user-attachments/assets/097e2c11-271e-4f89-b4b4-a5b188b28eaf)

- ### <span style="color: Yellow;"> **Step-04: Create/Configure a pipeline in Azure DevOps**.
  - Click on Pipeline:
   - follow the below instruction
   - will use classic editor

![image](https://github.com/user-attachments/assets/dcd44387-e409-46a9-840a-0789b65ce26c)
![image-1](https://github.com/user-attachments/assets/4325e94e-d346-41d2-b623-5270a8717714)
![image-2](https://github.com/user-attachments/assets/e1b3c1ad-45f6-4ba5-b22d-094169bc015d)
![image-3](https://github.com/user-attachments/assets/cbeb0989-b6dc-4b5b-9360-0554e423b58b)
![image-4](https://github.com/user-attachments/assets/622a6e70-1bfe-4882-acd5-c4560f2888a8)

- Configure the Pipeline.
  - Install NPM
![image-5](https://github.com/user-attachments/assets/0511306f-0790-4a57-a3fd-69eaf75b9bb1)

  - install
![image-6](https://github.com/user-attachments/assets/5b054117-1b78-4120-b551-da56d0938a8a)

  - build
![image-7](https://github.com/user-attachments/assets/e7a5d525-b611-4770-8ba5-213f37f48fbf)

  - Publish Artificat
![image-8](https://github.com/user-attachments/assets/4905aae3-49f4-4014-9afe-5c6b77f7b8d3)

  - app service
![image-9](https://github.com/user-attachments/assets/951e76bb-cab0-4578-bb7f-be75ce5e6773)
![image-10](https://github.com/user-attachments/assets/c7cdb4c3-1ae2-4f4d-855e-1a55cdf36f87)


  - Build the pipeline and works
![image-11](https://github.com/user-attachments/assets/cc368ac6-045d-4a8f-8ab9-6791f16b8a2b)

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
![image-15](https://github.com/user-attachments/assets/8820e575-1e3d-4858-a514-3c738e7c6a50)

![image-18](https://github.com/user-attachments/assets/c6c8d370-2ebf-4775-bfdc-c502f2d0b22c)
![image-19](https://github.com/user-attachments/assets/0fe19b00-f8be-4ae2-8b2a-dcfec6ad805f)


  - restart the webapp application.

  - I was getting the same page. Now, I have to rerun the pipeline.

  - Application is working fine.
  ![image-12](https://github.com/user-attachments/assets/1dc19fab-5d32-4af3-95bd-7ae708dde29a)

  - Export classic to YAML
  ![image-13](https://github.com/user-attachments/assets/7610857f-7ca2-432f-a03c-8e59f8454ea4)

## <span style="color: Yellow;"> Advantages of Using This Project </span>

- **Simplified CI/CD Process**: The project demonstrates a streamlined process for setting up continuous integration and continuous deployment using Azure DevOps.
- **Hands-On Learning**: Provides a practical example of deploying a real-time application, enhancing understanding of Azure DevOps pipelines.
- **Scalability**: Using Azure App Service allows for easy scaling of the application based on demand.
- **Automation**: Automates the build, test, and deployment processes, reducing manual intervention and potential errors.

## <span style="color: Yellow;"> Impact of Using This Project </span>

- **Improved Efficiency**: Automating the build and deployment process saves time and reduces the risk of human error.
- **Enhanced Collaboration**: Azure DevOps facilitates better collaboration among team members by providing a centralized platform for code, build, and deployment management.
- **Faster Time-to-Market**: Continuous integration and deployment enable faster release cycles, allowing new features and updates to reach users more quickly.
- **Reliability**: Deployment gates and blue-green deployment strategies ensure that only tested and approved changes are deployed to production, increasing the reliability of the application.

### Conclusion
This project provides a comprehensive guide to setting up Azure DevOps pipelines for building and deploying a YouTube clone application. By following the steps outlined, users can automate their CI/CD processes, improve collaboration, and ensure reliable deployments. The use of Azure App Service and deployment strategies like blue-green deployment further enhance the scalability and reliability of the application. This project serves as a valuable resource for anyone looking to implement DevOps practices in their workflow.


__Ref Link:__

- [YouTube Link](https://www.youtube.com/watch?v=3Nv-FzzrqYU&list=PLl4APkPHzsUXseJO1a03CtfRDzr2hivbD&index=5) 

- [install-node](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04)

- [install-node-js-and-npm](https://www.geeksforgeeks.org/how-to-install-node-js-and-npm-on-ubuntu/)



