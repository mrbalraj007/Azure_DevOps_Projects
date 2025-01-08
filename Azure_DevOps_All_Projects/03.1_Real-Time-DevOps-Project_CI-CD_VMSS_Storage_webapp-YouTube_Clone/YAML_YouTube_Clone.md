
# <span style="color: Yellow;">  YouTube Clone: Automating CI/CD with Azure DevOps: Blue-Green Deployment and Self-Hosted Agents on Azure VM Scale Sets</span>


![App_YouTube Clone_Compress](https://github.com/user-attachments/assets/c8637593-efce-42b6-ac95-ef90f4272772)

##  <span style="color: Yellow;"> Overview
This project provides a comprehensive guide to automating Continuous Integration and Continuous Deployment (CI/CD) using Azure DevOps. It covers two main topics: Blue-Green Deployment using Azure DevOps Release Pipelines and setting up Self-Hosted Agents using Azure Virtual Machine Scale Sets (VMSS). The project uses a YouTube clone application as a practical example to demonstrate the concepts and steps involved.

## <span style="color: Yellow;"> Prerequisites </span>

Before diving into this project, here are some skills and tools you should be familiar with:

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/04_Real-Time-DevOps-Project_CI-CD_secretsanta-generator)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
    - Update ```terraform.tfvars```.
 
- [x] [App Repo (YouTube Clone)](https://github.com/piyushsachdeva/Youtube_Clone)

- [x] __Azure Account__: You’ll need an Azure account to create resources like virtual Machine, AKS cluster, and manage pipelines.
- [x] __Terraform Knowledge__: Familiarity with Terraform to provision, manage, and clean up infrastructure.
- [x] __GitHub__: Experience with GitHub for version control and managing repositories.
- [x] __Command-Line Tools__: Basic comfort with using the command line for managing infrastructure and services.
- [x] __Basic CI/CD Knowledge__: Some understanding of Continuous Integration and Deployment is recommended.
- [x] __Linux VM__: Docker must be installed on a Linux virtual machine to run containers.

##  <span style="color: Yellow;"> Azure DevOps Release Pipelines: Blue-Green Deployment
This section focuses on setting up Azure DevOps release pipelines to automate the deployment process. It explains how to create a release pipeline using the GUI-based editor, configure continuous deployment triggers, and implement deployment gates for additional control. The blue-green deployment strategy is highlighted, showing how to use deployment slots to minimize downtime during deployments.

##  <span style="color: Yellow;"> Azure DevOps Self-Hosted Agents: Virtual Machine Scale Sets (VMSS)
This section delves into the setup and use of self-hosted agents on Azure VMSS. It compares Microsoft hosted agents with self-hosted agents, explaining the benefits and use cases for each. Detailed steps are provided to set up self-hosted agents on VMSS, register the agents with Azure DevOps, and use them in pipelines. The section also covers the benefits of using VMSS, such as automatic scaling and high availability.

##  <span style="color: Yellow;"> Key Points
- **Technologies Used**: Azure DevOps, Azure Virtual Machine Scale Sets (VMSS)
- **Self-Hosted Agents**: Dedicated agents for running CI/CD pipelines
- **Automatic Scaling**: Provisioning and de-provisioning VMs based on load
- **Extensions and Applications**: Installing necessary software on VMs
- **Service Connections**: Secure authentication for Azure resources
- **Automated Deployment**: Demonstrates how to automate the deployment process using Azure DevOps release pipelines.
- **Reduced Downtime**: Ensures minimal downtime during deployments with the blue-green deployment strategy.
- **Enhanced Control**: Provides additional control over the deployment process with deployment gates.
- **Scalability**: Allows for easy scaling of the application using Azure App Service and deployment slots.
- **Custom Software Installation**: Enables automatic installation of custom software on self-hosted agents.
- **High Performance**: Provides high performance and specific resource requirements with self-hosted agents.
- **Network Security**: Ensures secure handling of sensitive data by keeping it within a secure network.
- **Cost Efficiency**: Optimizes resource management and costs with automatic scaling based on demand.

## <span style="color: Yellow;">Setting Up the Infrastructure </span>

I have created a Terraform code to set up the entire infrastructure, including the installation of required Software, tools, and the Webapp automatically created.

Below is a terraform Code:

Once you [clone repo](https://github.com/mrbalraj007/Azure_DevOps_Projects/tree/main/Azure_DevOps_All_Projects/04_Real-Time-DevOps-Project_CI-CD_secretsanta-generator)</span> and run the terraform command.
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

### Step-by-Step Description

#### 1. Project Setup
- **Clone the Repository**: Clone the project repository from the source control.
- **Import into Azure DevOps**: Import the project into Azure DevOps and set up the necessary service connections.

#### 2. Create Virtual Machine Scale Set
- **Azure Portal**: Log in to the Azure portal and search for "Virtual Machine Scale Sets".
- **Create VMSS**: Click on "Create" and fill in the required details such as subscription, resource group, and region.
- **Select VM Size**: Choose an appropriate VM size (e.g., Standard B1s) and configure scaling options.
- **Networking and Management**: Configure networking options and set the upgrade mode to manual.

#### 3. Configure Extensions and Applications
- **Add Extensions**: Navigate to the "Extensions and Applications" section in the VMSS settings.
- **Install Azure DevOps Pipeline Agent**: Add the Azure DevOps pipeline agent extension to the VMSS.
- **Custom Scripts**: Optionally, add custom scripts to install additional software (e.g., npm, Azure CLI).

#### 4. Set Up Agent Pool in Azure DevOps
- **Project Settings**: Go to the project settings in Azure DevOps and navigate to the "Agent Pools" section.
- **Add Pool**: Create a new agent pool and select "Azure Virtual Machine Scale Set" as the pool type.
- **Configure Pool**: Select the appropriate Azure subscription and VMSS, and configure the scaling options.

#### 5. Use Self-Hosted Agent in Pipeline
- **Edit Pipeline**: Edit the existing pipeline to use the newly created self-hosted agent pool.
- **Specify Pool**: Update the pipeline configuration to specify the self-hosted agent pool.
- **Run Pipeline**: Trigger the pipeline to run using the self-hosted agent.

#### 6. Testing and Debugging
- **Monitor Agents**: Check the status of the agents in the Azure DevOps agent pool section.
- **Debug Issues**: Use Azure DevOps logs and VMSS monitoring tools to debug and fix any issues.

### <span style="color: Yellow;">Detailed Steps

#### <span style="color: Cyan;">Step 1: Project Setup
1. **Clone the Repository**: 
   - Use Git to clone the repository containing the project files.
   - Command: `git clone https://github.com/piyushsachdeva/Youtube_Clone`

2. **Import into Azure DevOps**:
   - Navigate to Azure DevOps and create a new project.
   - Import the cloned repository into the Azure DevOps project.

####  <span style="color: Cyan;">Step 2: Create Virtual Machine Scale Set
1. **Azure Portal**:
   - Log in to the Azure portal.
   - Search for "Virtual Machine Scale Sets" in the search bar
   - click on Azure CLI and run the following command
     ```sh
     az vmss show --resource-group <ResourceGroupName> --name <VMScaleSetName> --output table
     ```
   ![image-68](https://github.com/user-attachments/assets/622665b8-2f20-443d-ab93-18b77972a70c)

   - After creating your scale set, navigate to your scale set in the Azure portal and verify the following settings:
     - Upgrade policy - Manual
     - Scaling - Manual scale
   ![image-69](https://github.com/user-attachments/assets/99af45ec-1754-4db2-9fa2-4ca33fa14374)
   ![image-70](https://github.com/user-attachments/assets/4c8d951e-f097-4d5b-9d75-c062425fc634)

      **Important:**
      *Azure Pipelines does not support instance protection. Make sure you have the scale-in and scale set actions instance protections disabled.*

#### <span style="color: Cyan;">Step 3: Configure Extensions and Applications
1. **Add Extensions**:
   - Navigate to the "Extensions and Applications" section in the VMSS settings.
   - Click on "Add" to install extensions.
   ![image-78](https://github.com/user-attachments/assets/b0ae7aca-6774-4fee-89eb-be633d057efa)

   **Note:** *Part of provisining server, I have already created a storage account, container and uploaded the script in "Script container."*

2. **Custom Scripts**:
   - Optionally, add custom scripts to install additional software (e.g., npm, Azure CLI).
   - Example: 
     - Search for "Custom Script for Linux" extension.
      Upload a script file to install software:
      ![image-79](https://github.com/user-attachments/assets/ca39a85a-fd6e-4820-bd40-82d190a418ac)
      ![image-80](https://github.com/user-attachments/assets/ad4fdfe2-9f9b-4153-be40-d386020801a2)
      ![image-81](https://github.com/user-attachments/assets/874b1c7e-2e49-49b0-aff4-7fde56c64bc2)
      ![image-82](https://github.com/user-attachments/assets/d78d208f-c4d4-453f-89a6-049550af4af5)
      ![image-83](https://github.com/user-attachments/assets/71d66273-a0d4-4dbc-b44e-6860a101681c)
      ![image-84](https://github.com/user-attachments/assets/be60f556-0dff-499b-a91a-65b7de6dd8e5)
      ![image-85](https://github.com/user-attachments/assets/bf7a5000-eea9-492c-83cc-8f4ac2bbee2e)
      ![image-86](https://github.com/user-attachments/assets/4132edf1-4351-444b-a44b-eae9a440c44e)
      ![image-87](https://github.com/user-attachments/assets/22c016d4-a8b7-400f-92e2-24599bcbbbac)
      ![image-88](https://github.com/user-attachments/assets/6ceeb8f7-6462-42f9-9573-c814a5d40614)
      ![image-89](https://github.com/user-attachments/assets/306bf329-5b92-461a-ae6d-d4295706553d)
           - if above script failed then try with this one only  
 `#!/bin/bash apt-get update && apt-get install -y npm`

#### <span style="color: Cyan;"> Step 4: Set Up Agent Pool in Azure DevOps
1. **Project Settings**:
   - Go to the project settings in Azure DevOps.
   - Navigate to the "Agent Pools" section.

2. **Add Pool**:
   - Create a new agent pool and select "Azure Virtual Machine Scale Set" as the pool type.
   - Example:
     - Pool Name: `devops-demo_vm`
     - Azure Subscription: Select the appropriate subscription
     - VMSS: Select the created VMSS
     - Configure scaling options (e.g., maximum number of agents, idle instances)
3. **Install Azure DevOps Pipeline Agent**:
   - Add the Azure DevOps pipeline agent extension to the VMSS.
   - This extension allows the VMSS to act as a self-hosted agent for Azure DevOps pipelines.
   - Navigate to your Azure DevOps Project settings, select Agent pools under Pipelines, and select Add pool to create a new agent pool.
      ![image-71](https://github.com/user-attachments/assets/68eebfdd-4f9e-405b-ba16-1f1eb9089c9b)
      ![image-72](https://github.com/user-attachments/assets/7f9acfd0-1a81-4f2a-99b8-31e5248b3079)
      ![image-73](https://github.com/user-attachments/assets/ae27e25c-6228-4715-aeaa-f13c3ba65535)


   - VMSS UI
      ![image-74](https://github.com/user-attachments/assets/59df7eed-3eda-4fa3-a197-569707ebf41b)
   - Click on Instances and noticed thatLatest Model is showing `No`.
      ![image-75](https://github.com/user-attachments/assets/17333e2b-72b2-45b9-a275-1b5b32f1af95)
      ![image-76](https://github.com/user-attachments/assets/71437f04-0e95-49db-ac70-bdcb4308c083)

   - **Note**: - "Azure Pipeline Agent for Linux"
     - it will take 5-10 min to get active the connection for VMSS.
     - Go to azure DevOps Portal and noticed that agent is online and accessible now.
      ![image-77](https://github.com/user-attachments/assets/55e08ca8-81f7-491c-bcbb-31996791d79b)

#### <span style="color: Cyan;">  Step 5: Build the Pipeline
1. **Edit Pipeline**:
   - Click on pipeline and select `Azure Repos Git (YAML)`
   ![image-14](https://github.com/user-attachments/assets/0a13da8d-8a4f-49a1-8042-73d6b0c53bb7)
   ![image-15](https://github.com/user-attachments/assets/f655eca3-17f2-4a4f-b47f-96783184bc51)
   ![image-16](https://github.com/user-attachments/assets/9d63cbc0-5ab1-45aa-b154-fea11f6041a8)

   - it will generate the basic structure.

#### <span style="color: Cyan;">  Step 6: Use Self-Hosted Agent in Pipeline

1. **Edit Pipeline**:
   - Edit the existing pipeline to use the newly created self-hosted agent pool.
   - Example:
     - Update the pipeline YAML file to specify the agent pool:
       ```yaml
       pool:
         name: devops-demo_vm
       ```
      - 👉[Complete Pipeline]()👈 

2. **Run Pipeline**:
   - Trigger the pipeline to run using the self-hosted agent.
   - Monitor the pipeline execution to ensure it uses the self-hosted agent.

#### <span style="color: Cyan;">  Step 7: Testing and Debugging
1. **Monitor Agents**:
   - Check the status of the agents in the Azure DevOps agent pool section.
   - Ensure the agents are online and ready to execute pipeline jobs.

2. **Debug Issues**:
   - Use Azure DevOps logs and VMSS monitoring tools to debug and fix any issues.
   - Example: If a pipeline step fails due to missing software, use custom scripts to install the required software on the VMSS.

#### <span style="color: Cyan;">  Step 8: Verify the Artifacts
1. **Verify**:
   - Artficat will be produce once the pipeline executed as below.
         ![image-17](https://github.com/user-attachments/assets/882ee7fa-7270-4de3-aba8-4bd1d3b8e3e5)


#### <span style="color: Cyan;">  Step 9: Create WorkItem
1. **Create WorkItem**:
    ![image-21](https://github.com/user-attachments/assets/3978be50-1550-4cd5-b1fe-2825cdca6b32)
   - In workIteam, change the priority from `P2` to `P1`.
    ![image-25](https://github.com/user-attachments/assets/9aa7cc8e-2d9b-4b58-a216-00ca2908cb68)

2. **Create Query**:
   - Will create a query and save in `Shared Queries`
   ![image-22](https://github.com/user-attachments/assets/b7a5bef5-b9b8-403e-ad86-60a1fb40b60a)
   ![image-23](https://github.com/user-attachments/assets/3986998d-d102-4a88-ad9e-377c9b5fbc66)
   ![image-24](https://github.com/user-attachments/assets/6fcb2bc0-ed21-4a87-a652-db8cfdd9cecc)

3. **Create Chart in query**:
   ![image-26](https://github.com/user-attachments/assets/480dafe5-7163-4bc6-9d71-a288758721ab)
   ![image-27](https://github.com/user-attachments/assets/c787e9e6-c044-4cf4-977f-1600cb16d603)
   ![image-28](https://github.com/user-attachments/assets/81d164fa-719d-403a-beb2-9afe878a616c)

#### <span style="color: Cyan;">  Step 10: Create a slot in WebApp
1. **Slot in Webapp**:
   - Create a slot: 
   - Azure UI > Web App > Deployment Slot
      ![image-40](https://github.com/user-attachments/assets/bcfacc61-1af6-4969-bf7f-8b926a792e4d)
      ![image-41](https://github.com/user-attachments/assets/ddedb32d-6c51-4254-bb73-f314dcebc377)
      ![image-42](https://github.com/user-attachments/assets/c4061955-fcad-49d4-8a75-ee1df827b540)
      ![image-43](https://github.com/user-attachments/assets/829934d5-d398-49d5-aa1a-acd5be18f2c6)


#### <span style="color: Cyan;">  Step 11: Configure `Release Pipeline (CD)`
1. **To Configure the Dev Stage in CD pipeline**:

- 1.1. **Add Artifact & GateCheck in CD pipeline**:
   - Click on Release under pipelines and search as follow.
      ![image-18](https://github.com/user-attachments/assets/f848ae1b-cfa6-4a61-b26f-1d1490539148)
   
   - add artifact
      ![image-19](https://github.com/user-attachments/assets/7d7c82f4-d60a-497f-948e-ae8c79869f7a)

   - Enable auto triger CD pipeline
      ![image-20](https://github.com/user-attachments/assets/62a98c16-4b89-48d3-9d48-3e01f48f27a4)

   - Confiugre PreDeployment stage   
      ![image-29](https://github.com/user-attachments/assets/087b632a-360a-4baa-9af2-cbc7fe67c43b)
      ![image-30](https://github.com/user-attachments/assets/295c1534-10d9-455a-831a-059c6a45bd8d)
      ![image-31](https://github.com/user-attachments/assets/37e8ee2f-598b-4a32-84f2-19054685b141)


   - Configure the GateCheck in pipeline
      ![image-32](https://github.com/user-attachments/assets/6b9ba787-c2b0-419c-9fc9-6c07cfb56bf3)
      ![image-33](https://github.com/user-attachments/assets/fe1af4ab-f673-4b47-bd3b-e70e92f5d4e3)
      ![image-34](https://github.com/user-attachments/assets/c6ca3581-0aad-4d06-a068-217cd8b42db3)
      ![image-35](https://github.com/user-attachments/assets/f2e0b003-3b79-412f-8439-b2fc446a78b7)

  1.2. **Configure the Job**
   - Configure the Job in pipeline
      ![image-36](https://github.com/user-attachments/assets/018daaec-35d7-441d-a275-360101066628)
      ![image-37](https://github.com/user-attachments/assets/461ddb20-c9c8-45cf-a38c-3e063c1a848f)
      ![image-38](https://github.com/user-attachments/assets/c8843c1c-48ab-4b86-a435-6d3a2703ba99)


  1.3 **Configure the slot Option**
   ![image-39](https://github.com/user-attachments/assets/f86cac5c-c5de-453d-beb9-66c14055e16e)
   ![image-44](https://github.com/user-attachments/assets/a9235a91-40d0-471f-b1ce-b438dd805d38)
   ![image-46](https://github.com/user-attachments/assets/18f484f9-265f-44ce-9e9c-a6c04aa4473c)
   ![image-45](https://github.com/user-attachments/assets/b90a8d65-2a26-4252-99aa-5cd2100d59b3)

   - Click `Save`

2. **To Configure the Prod Stage in CD pipeline**:
- To add Production stage.
  - clone the exisiting stage.
   ![image-47](https://github.com/user-attachments/assets/47c4a27f-34b2-444d-b0eb-4db477d971b1)
   ![image-48](https://github.com/user-attachments/assets/14200e2a-4b8e-4f8d-9766-7b4531017867)

   - To add prestage for Production stage.
   ![image-49](https://github.com/user-attachments/assets/df514638-d570-47f4-9d32-5d4b12ca7b81)
   ![image-50](https://github.com/user-attachments/assets/6e7a6180-d3c9-4393-a0f0-5bb2887cce62)


  - Change the slot from staging to prod.
   ![image-51](https://github.com/user-attachments/assets/6a65afad-b0b1-4d0d-ba5c-048f35a25797)

#### <span style="color: Cyan;">  Step 12: Update the query and workIteam in pipeline
2. **To Configure query and workIteam in CD pipeline**:
  - run the pipeline and Cd job would be failed because we have set the workitem query set to `doing` while it should be in `done` state.
   ![image-52](https://github.com/user-attachments/assets/e136019b-0975-4d24-a1f0-9e46279b2593)
  - also, we need to update the query as below:
   ![image-54](https://github.com/user-attachments/assets/64a5637f-e8de-4e62-9294-2225998952d9)
  - Add security in query:
   ![image-55](https://github.com/user-attachments/assets/f091e00b-c187-4bad-8f2d-8c1f1fba2d3f)
   ![image-56](https://github.com/user-attachments/assets/2fee5ecc-0f51-478b-886a-5b24ac72bc25)
   ![image-57](https://github.com/user-attachments/assets/f5cfc399-0607-42a8-855e-b43776edc78a)

  - change state from doing to done in workitem.
   ![image-53](https://github.com/user-attachments/assets/e27128e9-d88b-434c-bdd2-b5231fa96609)

2. **ReRun the pipeline again**:
   - CI passed
   ![image-58](https://github.com/user-attachments/assets/eec86c76-b7e8-49c3-a130-2321de8565cb)
   - CD- also passed
   ![image-59](https://github.com/user-attachments/assets/13fb2dda-ef18-46ca-bc16-7fd91f350f4c)
   ![image-60](https://github.com/user-attachments/assets/1a4a2b07-7833-4160-b0ca-9376fc0b2e37)

- WebSite is acecssible on staging.
   ![image-61](https://github.com/user-attachments/assets/d6ebe530-56ea-4f48-97fe-489161dae6cd)

- It's asking for approval for Prod Environment.
   ![image-62](https://github.com/user-attachments/assets/707eb23d-50ee-4e27-8752-def37db379e9)
   ![image-63](https://github.com/user-attachments/assets/dedd340f-29c7-4f29-8f99-6946d61c18af)
   ![image-64](https://github.com/user-attachments/assets/75c294e7-3f79-4c49-a8c7-ce58936be928)

- Application is also accessible and working fine in Prod.   
   ![image-65](https://github.com/user-attachments/assets/bd417d71-03ac-49b0-8cb2-50ab25a1afae)

3. **Swap the slot**:
   - swap the from UI
   - Current:
   ![image-66](https://github.com/user-attachments/assets/b1acc29e-c73e-4055-8759-8cca7043f455)
   ![image-67](https://github.com/user-attachments/assets/14acc970-1b64-4264-bb9a-b17c0f1ef025)

<!-- ```sh
To include the agent pool name and agent name in the ./config.sh command, you can use the --pool and --agent options respectively. Here’s the updated command:

bash
Copy code
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

``` -->
### Advantages of Using This Project
- **Automated Deployment**: The project demonstrates how to automate the deployment process using Azure DevOps release pipelines.
- **Reduced Downtime**: Blue-green deployment strategy ensures minimal downtime during deployments by using deployment slots.
- **Enhanced Control**: Deployment gates provide additional control over the deployment process, ensuring only approved changes are deployed to production.
- **Scalability**: Using Azure App Service and deployment slots allows for easy scaling of the application based on demand.

### Impact of Using This Project
- **Improved Efficiency**: Automating the deployment process saves time and reduces the risk of human error.
- **Increased Reliability**: Deployment gates and blue-green deployment strategies ensure that only tested and approved changes are deployed to production, increasing the reliability of the application.
- **Faster Time-to-Market**: Continuous deployment enables faster release cycles, allowing new features and updates to reach users more quickly.
- **Better User Experience**: Reduced downtime during deployments ensures a better user experience, as the application remains available during updates.
    
## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete 

  - run the terraform command.
```bash
Terraform destroy --auto-approve
```


### Conclusion
By following the steps outlined in this project, users can automate their CI/CD processes, improve control over deployments, and ensure reliable and scalable application updates. The use of blue-green deployment and self-hosted agents further enhances the user experience by minimizing downtime and providing greater control and security. This project serves as a valuable resource for anyone looking to implement DevOps practices in their workflow.


__Ref Link:__


- [VMSS Setup](https://www.youtube.com/watch?v=xO1RG7Cc0N8&list=PLl4APkPHzsUXseJO1a03CtfRDzr2hivbD&index=10)

- [CI-CD Pipeline Video](https://www.youtube.com/watch?v=acJErWFS15w&list=PLl4APkPHzsUXseJO1a03CtfRDzr2hivbD&index=6)

- [Install-node](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04)


- [Install-node-js-and-npm-on-ubuntu](https://www.geeksforgeeks.org/how-to-install-node-js-and-npm-on-ubuntu/)

- [Scale-set-agents setup](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/scale-set-agents?view=azure-devops)
