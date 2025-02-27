
# Seamless Multi-Cloud Deployment with Azure DevOps, Terraform, and Ansible

<!-- # Automating Multi-Cloud Deployments with Azure DevOps, Terraform, and Ansible: A Comprehensive Guide -->
![Image](https://github.com/user-attachments/assets/b62a8efb-cfd2-47cc-9abf-2f15d805c2e5)

## Overview
This project demonstrates a multi-cloud automation setup using Azure DevOps, Terraform, and Ansible. The goal is to automate the deployment of a .NET application across both AWS and Azure environments. The project is divided into four parts, each focusing on different aspects of the automation process.

## Key Points
- **Azure DevOps** is used for the CI/CD workflow.
- **Terraform** is used to provision infrastructure on AWS and Azure.
- **Ansible** is used for configuration management and application deployment.
- **Remote State File** is stored in Azure Blob Storage to maintain the state of the infrastructure.
- **Self-Hosted Agent** is used to overcome the limitations of ephemeral agents provided by Azure DevOps.

## Prerequisites

Before diving into this project, here are some skills and tools you should be familiar with:

- [x] Need to Create a PAT access Token
- [x] Need to Install extension
  - [AWS Toolkit for Azure DevOps](https://marketplace.visualstudio.com/items?itemName=AmazonWebServices.aws-vsts-tools) 
  - [Custom-terraform-tasks](https://marketplace.visualstudio.com/items?itemName=JasonBJohnson.azure-pipelines-tasks-terraform)
  - [Terraform installation](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks) 

- [x] [Terraform code](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/12_Real-Time-DevOps-Project_CI-CD_Terraform_ACR_Storage_WebApp_SQL_Front-Door/Terraform_Code)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
    - Update ```terraform.tfvars```
    - Update token and project name in `selfthost_agentvm.tf`
    - Note: In terraform, whereever you find `xxxxxx` then replace the value accordingly.
- [x] Application Repo:     
    - [x] [Infra as Code](https://github.com/mrbalraj007/infra-as-code.git)
    

## Tools and Technologies
- **Azure DevOps**: For CI/CD pipeline management.
- **Terraform**: For infrastructure provisioning.
- **Ansible**: For configuration management and application deployment.
- **AWS**: For provisioning EC2 instances.
- **Azure**: For provisioning virtual machines.
- **.NET**: For the application being deployed.
- **Ubuntu**: As the base operating system for the virtual machines.

## <span style="color: Yellow;">Setting Up the Infrastructure </span>

I have created a Terraform code to set up the entire infrastructure, including the installation of required applications, tools, and storage automatically created.

**Note**--> Selfthosted agent vm will take approx 5 to 10 min to install the all required software/packages.

- &rArr; <span style="color: brown;">Virtual machines will be created named as ```"devopsdemovm"```

- &rArr;<span style="color: brown;"> Ansible Install
- &rArr;<span style="color: brown;"> Azure CLI Install
- &rArr;<span style="color: brown;"> Storage Acccount & Blob Setup
- &rArr;<span style="color: brown;"> .Net Installation

First, we'll create the necessary virtual machines using ```terraform``` code. 

  - Below is a terraform Code:

  - Once you [clone repo](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/12_Real-Time-DevOps-Project_CI-CD_Terraform_ACR_Storage_WebApp_SQL_Front-Door/Terraform_Code)</span> and run the terraform command.
    ```bash
    $ ls -l
    -rw-r--r-- 1 bsingh 1049089   573 Feb 19 15:37 aws_connection.tf       
    -rw-r--r-- 1 bsingh 1049089   876 Feb 24 15:57 azure_rm_connection.tf  
    -rw-r--r-- 1 bsingh 1049089   564 Feb 19 13:54 DevOps_UI.tf
    -rw-r--r-- 1 bsingh 1049089   419 Feb 19 13:55 group_lib.tf
    -rw-r--r-- 1 bsingh 1049089  3243 Feb 27 10:59 id_rsa
    -rw-r--r-- 1 bsingh 1049089   725 Feb 27 10:59 id_rsa.pub
    -rw-r--r-- 1 bsingh 1049089   769 Feb 20 11:27 output.tf
    -rw-r--r-- 1 bsingh 1049089   528 Feb 18 21:13 provider.tf
    drwxr-xr-x 1 bsingh 1049089     0 Feb 20 15:59 scripts/
    -rw-r--r-- 1 bsingh 1049089  6175 Feb 20 15:57 selfthost_agentvm.tf    
    -rw-r--r-- 1 bsingh 1049089   362 Feb 19 12:35 ssh_key.tf
    -rw-r--r-- 1 bsingh 1049089  1180 Feb 21 12:44 Storage.tf
    -rw-r--r-- 1 bsingh 1049089 72270 Feb 27 11:02 terraform.tfstate       
    -rw-r--r-- 1 bsingh 1049089   183 Feb 27 10:59 terraform.tfstate.backup
    -rw-r--r-- 1 bsingh 1049089  3654 Feb 21 13:13 terraform.tfvars        
    -rw-r--r-- 1 bsingh 1049089  3999 Feb 20 11:05 variable.tf
    ```

- You need to run terraform command.
  - Run the following command.
  ```bash
  terraform init
  terraform fmt
  terraform validate
  terraform plan
  terraform apply 
  # Optional <terraform apply --auto-approve>
  ```
![alt text](image.png)
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

![alt text](image-5.png)


### <span style="color: cyan;"> Verify the Installation 

- [x] <span style="color: brown;"> Docker version
```bash
azureuser@devopsdemovm:~$  docker --version
Docker version 24.0.7, build 24.0.7-0ubuntu4.1


docker ps -a
azureuser@devopsdemovm:~$  docker ps
```
- [x] <span style="color: brown;"> Ansible version
```bash
azureuser@devopsdemovm:~$ ansible --version
ansible [core 2.17.8]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/azureuser/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/azureuser/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.10.12 (main, Feb  4 2025, 14:57:36) [GCC 11.4.0] (/usr/bin/python3)
  jinja version = 3.0.3
  libyaml = True
```
- [x] <span style="color: brown;"> Azure CLI version
```bash
azureuser@devopsdemovm:~$ az version
{
  "azure-cli": "2.67.0",
  "azure-cli-core": "2.67.0",
  "azure-cli-telemetry": "1.1.0",
  "extensions": {}
}
```
- [x] <span style="color: brown;"> Project Creation
![alt text](image-1.png)
- [x] <span style="color: brown;"> Service Connection
![alt text](image-2.png)
- [x] <span style="color: brown;"> Import Repo 
![alt text](image-3.png)
- [x] <span style="color: brown;"> Resource Group & Storage account Creation
![alt text](image-4.png)

- Upload the private and public keys in library from a secure files as below.
![alt text](image-6.png)

**Note**: It would be the same keys which was created during the provision the infra.

## Step-by-Step Execution

### Part 1: Project Overview
1. **Introduction**: Overview of the project and its phases.
2. **Architecture**: High-level architecture diagram and workflow explanation.
3. **Azure DevOps**: Setting up the CI/CD workflow.

### Part 2: Build .NET Application
1. **Repository Setup**: Structure of the .NET application repository.
2. **Build Pipeline**: Steps to build the .NET application using Azure DevOps.
3. **Artifact Publishing**: Publishing the build artifact for later use.

### Part 3: Terraform Pipeline
1. **Remote State File**: Setting up the remote state file in Azure Blob Storage.
2. **Terraform Scripts**: Writing Terraform scripts to provision infrastructure on AWS and Azure.
3. **Pipeline Execution**: Running the Terraform pipeline to provision the infrastructure.

### Part 4: Deploy App using Ansible
1. **Self-Hosted Agent**: Setting up and using a self-hosted agent for stable SSH connections.
2. **Dynamic Inventory**: Creating a dynamic inventory for Ansible.
3. **Ansible Playbook**: Writing and executing Ansible playbooks to deploy the .NET application.




## <span style="color: cyan;"> Pipeline - Build (Package)
   - Build the packages pipeline first.
  ![alt text](image-7.png)
  ![alt text](image-8.png)
  ![alt text](image-9.png)
  ![alt text](image-10.png)

🔔Here is the [Updated pipeline code]().🔔

- Build the pipeline status.
![alt text](image-12.png)

- Verify the artifact published or not.
![alt text](image-11.png)

- Rename the pipeline as below, because that name will be used in next pipeline.
  ![alt text](image-13.png)
  ```sh
  Name: Build-Pipeline
  ```
  ![alt text](image-14.png)

## <span style="color: cyan;"> Pipeline - Create Infra
- Create a new pipeline for AWS and Azure infra Setup.

- We choose startup pipeline and steps would be same as we followed in build pipeline.

- We choose startup pipeline and steps would be same as we followed in build pipeline.

- 🔔Here is the [Updated pipeline for Infra Setup]().🔔

- Here the pipeline but few parameter need to be adjusted as below.

- In `Terraform init`, adjust the connection, storage account etc.
  ![alt text](image-15.png)

- In `Terraform plan`, adjust the connection, AWS region etc.
  ![alt text](image-16.png)
  ![alt text](image-17.png)

- In `Terraform apply`,adjust the connection, AWS region etc.
  ![alt text](image-18.png)
  ![alt text](image-19.png)

- Rename the pipeline as below.
![alt text](image-20.png)

- Run the pipeline
  - It will ask for permission and approve it.
  ![alt text](image-21.png)

- Pipeline Status:
![alt text](image-24.png)

### <span style="color: cyan;"> Verify the infra setup in both cloud Environment
- AWS
  ![alt text](image-22.png)
- Azure
![alt text](image-23.png)

## <span style="color: cyan;"> Selfhosted Agent setup
- Will take putty session of selfthosted agent VM and run the following command-

-Verify agent status
![alt text](image-34.png)

- if agent is not visible then run the following command to Register the selfhost agent. 

  - Run the following code to register selfhost agent.
    ```sh
    ./config.sh --unattended --url https://dev.azure.com/<organiazation Name> --auth pat --token <token value> --pool Default --agent <agentname> --acceptTeeEula
    sudo ./svc.sh install
    sudo ./svc.sh start
    ```

## <span style="color: cyan;"> Pipeline - Application with Ansible setup
- login into Azure DevOps portal and go to folder `Selfhosted-Ansible` and update as below.

- File `add_to_known_hosts.py`
  - changes the script as below.
  ![alt text](image-25.png)
  ![alt text](image-26.png)

- File `fetch_state_file.py`
  - SAS token need to be generated from blob.

  - How to [Generate SAS token](https://www.youtube.com/watch?v=1GV8DmZqkIo) 
  ![alt text](image-28.png)
  ![alt text](image-29.png)
  ![alt text](image-30.png)

  - Update the SAS token into the same file as below.
  ![alt text](image-27.png)

- Now, we have to upload the private key in selfthosted agent under direcoty (`/home/azureuser/.ssh`)
![alt text](image-31.png)

  - Change the permission.
  ```bash
  chmod 600 id_rsa
  ```
  ![alt text](image-38.png)

- Create a new pipeline.

- Adjust the perramerts.
  - Select the right project
  - Select the build Pipeline which generated the artifact.
  ![alt text](image-33.png)


- Run the pipeline and it will ask for permission.
  ![alt text](image-32.png)


## <span style="color: red;">  Troubleshooting
- Pipeline failed because I was encountring issue with related to environment and python.
![alt text](image-35.png)

```sh
Based on the error message, it seems there are a few issues:
1. The virtual environment `myenv` is not found.
2. The `python` command is not found.
3. The dynamic inventory file `dynamic_inventory.json` is not being parsed correctly.
```

Additionally, created a `requirements.txt` file in the `/multi-cloud-project/Selfhosted-Ansible` directory to install necessary Python packages.

- Create a new file to list the required Python packages.

```plaintext
azure-storage-blob
ansible
```

<!-- ********
Fix:
Check if the virtual environment (myenv) was actually created. Run the following:
```bash
ls -l myenv
```
If myenv doesn't exist, create it:
```bash
python3 -m venv myenv
```
Then, activate it:
```bash
source myenv/bin/activate
```
If you're running this in an Azure DevOps pipeline, make sure the virtual environment path is correct and relative to the working directory.


ModuleNotFoundError: No module named 'azure'

Your Python script fetch_state_file.py is trying to import azure.storage.blob, but the module is missing.
Fix: Install the required module by running:
```bash
pip install azure-storage-blob
```
If using a virtual environment, activate it first:
```bash
source venv/bin/activate  # For Linux/macOS
venv\Scripts\activate     # For Windows
``` -->

- 🔔Here is the [Updated pipeline for Infra Setup]().🔔

- Rerun the pipeline and verify the status.
![alt text](image-45.png)

- Verify the dynamic_inventory file is created or not.
```sh
cd /home/azureuser/myagent/_work/ansible-files

azureuser@devopsdemovm:~/myagent/_work/ansible-files$ ls -la
total 88
drwxr-xr-x  2 azureuser azureuser  4096 Feb 27 00:59 .
drwxr-xr-x 10 azureuser azureuser  4096 Feb 27 00:28 ..
-rw-r--r--  1 azureuser azureuser   332 Feb 27 00:59 Proj1.service
-rw-r--r--  1 azureuser azureuser   887 Feb 27 00:59 add_to_known_hosts.py
-rw-r--r--  1 azureuser azureuser  2123 Feb 27 00:59 app-deploy-playbook.yaml
-rw-r--r--  1 azureuser azureuser   613 Feb 27 00:59 dynamic_inventory.json
-rw-r--r--  1 azureuser azureuser   886 Feb 27 00:59 fetch_state_file.py
-rw-r--r--  1 azureuser azureuser  1212 Feb 27 00:59 parse_ips_from_state.py
-rw-r--r--  1 azureuser azureuser   122 Feb 27 00:59 ping-playbook.yaml
-rw-r--r--  1 azureuser azureuser    29 Feb 27 00:59 requirements.txt
-rw-r--r--  1 azureuser azureuser 47537 Feb 27 00:59 state_file.tfstate
```
```sh
ansible-inventory --list -i dynamic_inventory.json
```
![alt text](image-37.png)

- Validate the JSON format:
```bash
cat dynamic_inventory.json | jq .
```
![alt text](image-36.png)



- All Pipeline Status
![alt text](image-39.png)

- Verify application accisibility
  - Try to access application on `port 5000` (<PublicIPAddress:5000>)
  - From AWS EC2
  ![alt text](image-40.png)
  ![alt text](image-41.png)

  - From Azure VM
![alt text](image-42.png)
![alt text](image-43.png)

Congratulations, Application is accessible.🚀

## <span style="color: yellow;"> Pipeline for Cleanup Infra Setup.</span>

 - Pipeline Status
 ![alt text](image-44.png)

- Here is the 👉[Updated pipeline for delete](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/12_Real-Time-DevOps-Project_CI-CD_Terraform_ACR_Storage_WebApp_SQL_Front-Door/Pipeline/Destroy%20Infra.md)👈 

## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete `ssh_key`  and `Storage account`.

- Run the terraform command.
  ```bash
  Terraform destroy --auto-approve
  ```
![alt text](image-46.png)

<!-- - I was getting the below error message while deleting the setup. It is getting failed in deleting `ResourceGroup`

- Run the destroy command and it will delete `ResourceGroup` as well. -->
 

## Challenges
- **Ephemeral Agents**: Using Microsoft-hosted agents posed challenges due to their ephemeral nature, making SSH connections difficult.
- **State Management**: Managing the state file in a multi-cloud environment required careful handling to ensure consistency.
- **Dynamic Inventory**: Creating a dynamic inventory for Ansible to manage instances across both AWS and Azure.

## Benefits
- **Automation**: Reduces manual effort and potential errors in deploying and managing infrastructure.
- **Scalability**: Easily scalable to manage more instances or additional cloud providers.
- **Consistency**: Ensures consistent deployment and configuration across different environments.
- **Learning**: Provides valuable insights into multi-cloud management and automation tools.

## Conclusion
This project showcases the power of automation in managing multi-cloud environments. By leveraging Azure DevOps, Terraform, and Ansible, we can achieve consistent and scalable deployments across AWS and Azure. The challenges faced during the project provided valuable learning experiences, and the benefits of automation were clearly demonstrated. This setup can be further enhanced with additional features and optimizations in the future.

**Ref Link**: 

- [YouTube Video](https://www.youtube.com/watch?v=9Dt1668AMUc&list=PLWZd6M4V8nhHF4LxONokJ51AJ3z3Cj4rN)
- [Integrate Azure DevOps with AWS, AWS Toolkit"](https://www.youtube.com/watch?v=DHiUX2WqyWM&ab_channel=RameshGupta)
- Azure Extension 
  - [AWS Toolkit for Azure DevOps](https://marketplace.visualstudio.com/items?itemName=AmazonWebServices.aws-vsts-tools)
  - [Custom-terraform-tasks](https://marketplace.visualstudio.com/items?itemName=JasonBJohnson.azure-pipelines-tasks-terraform)
  - [Terraform installation](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks)
- [Terraform code for "azuredevops_serviceendpoint_aws"](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_aws)
- [Installing Ansible](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html)
- [Grant limited access to Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-sas-overview)
- [Create-service-sas](https://learn.microsoft.com/en-us/rest/api/storageservices/create-service-sas)
- [Change Timezone and date](https://phoenixnap.com/kb/how-to-set-or-change-timezone-date-time-ubuntu)