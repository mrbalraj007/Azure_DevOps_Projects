
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

- [x] [Terraform code](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/13_Real-Time-DevOps-Project_CI-CD_Terraform_Multi-Cloud_Automation/Terraform_Code)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
    - Update ```terraform.tfvars```
    - Update token and project name in `selfthost_agentvm.tf`
    - Note: In terraform, whereever you find `xxxxxx` then replace the value accordingly.
- [x] Application Repo:     
    - [x] [multi-cloud-project](https://github.com/mrbalraj007/multi-cloud-project.git)
    

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

  - Once you [clone repo](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/13_Real-Time-DevOps-Project_CI-CD_Terraform_Multi-Cloud_Automation/Terraform_Code)</span> and run the terraform command.
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
![Image](https://github.com/user-attachments/assets/ec2fb16f-d7f5-4de6-9831-b9a64829dc7d)
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

![Image](https://github.com/user-attachments/assets/27233f0b-3fab-49ec-893e-8c24431e0ebb)


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
![Image](https://github.com/user-attachments/assets/c641826f-9db1-431b-a27c-a0d57669ae37)
- [x] <span style="color: brown;"> Service Connection
![Image](https://github.com/user-attachments/assets/a7952cbf-b200-4209-ad5e-732b23647c23)
- [x] <span style="color: brown;"> Import Repo 
![Image](https://github.com/user-attachments/assets/eb5e0859-87c7-4cef-8518-f9713b432306)
- [x] <span style="color: brown;"> Resource Group & Storage account Creation
![Image](https://github.com/user-attachments/assets/ed3ac689-7877-4128-b85d-80b8aedb51dc)

- Upload the private and public keys in library from a secure files as below.
![Image](https://github.com/user-attachments/assets/11cae9a2-e347-40d3-81b0-996616a28f7f)

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
  ![Image](https://github.com/user-attachments/assets/2e4c50d8-f8e5-44ec-846e-53cd0fa96672)
  ![Image](https://github.com/user-attachments/assets/659358b7-fb14-4abf-8a14-9213f60584e1)
  ![Image](https://github.com/user-attachments/assets/464cb7d9-f76c-4974-9c15-c869319a5830)
  ![Image](https://github.com/user-attachments/assets/6cd3d7ce-7efc-4c11-a3d5-6179d61df779)

🔔Here is the [Updated pipeline code](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/13_Real-Time-DevOps-Project_CI-CD_Terraform_Multi-Cloud_Automation/Pipeline/application_pipeline.md).🔔

- Build the pipeline status.
![Image](https://github.com/user-attachments/assets/9d495524-08ac-4d43-b543-d972ccce7ccc)

- Verify the artifact published or not.
![Image](https://github.com/user-attachments/assets/f0492186-3a19-4137-b8a5-6935ce6e6a0d)

- Rename the pipeline as below, because that name will be used in next pipeline.
  ![Image](https://github.com/user-attachments/assets/f7e85e85-3428-46bb-bb0c-c2b36e63befa)
  ```sh
  Name: Build-Pipeline
  ```
  ![Image](https://github.com/user-attachments/assets/97b31472-4ba0-4972-843a-c68e11ef3f60)

## <span style="color: cyan;"> Pipeline - Create Infra
- Create a new pipeline for AWS and Azure infra Setup.

- We choose startup pipeline and steps would be same as we followed in build pipeline.

- We choose startup pipeline and steps would be same as we followed in build pipeline.

- 🔔Here is the [Updated pipeline for Infra Setup](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/13_Real-Time-DevOps-Project_CI-CD_Terraform_Multi-Cloud_Automation/Pipeline/Create%20Infra.md).🔔

- Here the pipeline but few parameter need to be adjusted as below.

- In `Terraform init`, adjust the connection, storage account etc.
  ![Image](https://github.com/user-attachments/assets/d6e10a4b-27dd-4138-b762-3bed7da4b3ea)

- In `Terraform plan`, adjust the connection, AWS region etc.
  ![Image](https://github.com/user-attachments/assets/779510d8-45bd-4b34-be76-86679814ea1e)
  ![Image](https://github.com/user-attachments/assets/52c99dea-5a98-4585-b00e-148c53dd199e)

- In `Terraform apply`,adjust the connection, AWS region etc.
  ![Image](https://github.com/user-attachments/assets/0214c9cd-f6fc-4088-bc0a-451c69d59d1c)
  ![Image](https://github.com/user-attachments/assets/83abf871-826f-4b65-ba7d-9bbe3992db9a)

- Rename the pipeline as below.
![Image](https://github.com/user-attachments/assets/787b2923-58ed-4da5-aa65-352c7fe83678)

- Run the pipeline
  - It will ask for permission and approve it.
  ![Image](https://github.com/user-attachments/assets/e59842c3-18fc-42b0-abbd-cf8eb440d74e)

- Pipeline Status:
  ![Image](https://github.com/user-attachments/assets/4c7d105b-1f41-49ca-b593-5317ac96b467)

### <span style="color: cyan;"> Verify the infra setup in both cloud Environment
- AWS
  ![Image](https://github.com/user-attachments/assets/84a8bbb0-c650-4035-bea5-316b6d31c187)
- Azure
  ![Image](https://github.com/user-attachments/assets/2cf128bf-d7d4-4b51-89cb-843e3a5ec556)

## <span style="color: cyan;"> Selfhosted Agent setup
- Will take putty session of selfthosted agent VM and run the following command-

- Verify agent status
![Image](https://github.com/user-attachments/assets/09cbb3e5-b6af-48d1-9a9b-d6fabc3dcbde)

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
  ![Image](https://github.com/user-attachments/assets/61e02eba-2174-40fd-ab10-97696e32bb63)
  ![Image](https://github.com/user-attachments/assets/c0be38ad-3d33-4bff-9efc-d09a790b7c3e)

- File `fetch_state_file.py`
  - SAS token need to be generated from blob.

  - How to [Generate SAS token](https://www.youtube.com/watch?v=1GV8DmZqkIo) 
  ![Image](https://github.com/user-attachments/assets/1a80a3ac-11df-4ab2-8cba-2702ce5e4927)
  ![Image](https://github.com/user-attachments/assets/57f306ff-b3ec-4d34-afb1-11be44a33254)
  ![Image](https://github.com/user-attachments/assets/6b971421-fb91-45f9-852b-c7fd6006359a)


  - Update the SAS token into the same file as below.
  ![Image](https://github.com/user-attachments/assets/33296796-63a2-4c91-a7e3-43df5cbb421f)

- Now, we have to upload the private key in selfthosted agent under direcoty (`/home/azureuser/.ssh`)
![Image](https://github.com/user-attachments/assets/7b6b8891-e635-48f5-9467-9fec8abf996f)

  - Change the permission.
  ```bash
  chmod 600 id_rsa
  ```
  ![Image](https://github.com/user-attachments/assets/b4d2be18-ff90-4f3a-8ebf-e4fceaa5fb6d)

- Create a new pipeline (Application).

- Adjust the perramerts.
  - Select the right project
  - Select the build Pipeline which generated the artifact.
  ![Image](https://github.com/user-attachments/assets/31bd1610-f9a2-436f-902a-9bdfb1d4bc14)

- Run the pipeline and it will ask for permission.
  ![Image](https://github.com/user-attachments/assets/7f609450-94a5-451f-8a12-682b456abf6b)


## <span style="color: red;">  Troubleshooting
- Pipeline failed because I was encountring issue with related to environment and python.
![Image](https://github.com/user-attachments/assets/b0227731-916e-400e-8606-ce69bddb91e8)

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

- 🔔Here is the [Updated pipeline for Application Setup with Ansible](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/13_Real-Time-DevOps-Project_CI-CD_Terraform_Multi-Cloud_Automation/Pipeline/selfthosted.md).🔔

- Rerun the pipeline and verify the status.
![Image](https://github.com/user-attachments/assets/c39a8e91-6cf3-4c12-9add-8a67256aa718)

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
![Image](https://github.com/user-attachments/assets/1aa454e5-636b-4179-b2c7-33ad415b845d)

- Validate the JSON format:
```bash
cat dynamic_inventory.json | jq .
```
![Image](https://github.com/user-attachments/assets/a5a32ff5-9440-4798-b46d-c585a4e2642d)

## <span style="color: cyan;"> All Pipeline Status
- All pipeline is working fine.
![Image](https://github.com/user-attachments/assets/d2737442-e232-4672-aa24-ea23d162a4b5)

- Verify application accisibility
  - Try to access application on `port 5000` (<PublicIPAddress:5000>)
  - From `AWS EC2`
  ![Image](https://github.com/user-attachments/assets/3e78662a-8d35-497e-8c78-c9ae6db16a0f)
  ![Image](https://github.com/user-attachments/assets/2316a719-9867-4494-bcb9-11ee23cae19d)

  - From `Azure VM`
  ![Image](https://github.com/user-attachments/assets/1f75d576-31ac-400a-8cf7-b01a9ffae0d2)
  ![Image](https://github.com/user-attachments/assets/8ee3f2c7-a188-4929-b10c-63026d0ef956)

**Congratulations, Application is accessible**.🚀

## <span style="color: yellow;"> Pipeline for Cleanup Infra Setup.</span>

 - Pipeline Status
 ![Image](https://github.com/user-attachments/assets/9fa7f2e4-6943-4684-8e0a-1f3efbd4e072)

- Here is the 👉[Updated pipeline for delete](https://github.com/mrbalraj007/Azure_DevOps_Projects/blob/main/Azure_DevOps_All_Projects/13_Real-Time-DevOps-Project_CI-CD_Terraform_Multi-Cloud_Automation/Pipeline/Destroy%20Infra.md)👈 

## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete `ssh_key`  and `Storage account`.

- Run the terraform command.
  ```bash
  Terraform destroy --auto-approve
  ```
![Image](https://github.com/user-attachments/assets/bd05ed5e-d3ef-4aac-8519-19037bf8b393)

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