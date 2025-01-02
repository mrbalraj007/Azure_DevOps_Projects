
 
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

