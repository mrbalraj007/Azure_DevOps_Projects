
# <span style="color: Yellow;"> End-to-End Azure DevOps Setup for Microservices and CI/CD Pipelines</span>


In the world of DevOps, Continuous Integration (CI) plays a pivotal role in automating the testing and deployment of applications. Azure DevOps has become a popular platform for managing these processes. In this technical blog, we will walk through the steps involved in migrating a GitHub-based CI pipeline to Azure DevOps, leveraging Docker for containerization and Azure Container Registry (ACR) to store Docker images. This project will help streamline your development workflows by automating the build and push stages, improving consistency across different environments.

## <span style="color: Yellow;"> Prerequisites </span>

Before diving into this project, here are some skills and tools you should be familiar with:

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/DevOps_free_Bootcamp/tree/main/19.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box)<br>
  __Note__: Replace resource names and variables as per your requirement in terraform code
  - Generate the ssh key in ```id_rsa``` format.
  - Update ```terraform.tfvars``` as per your requirement.
 

- [x] [App Repo (Simple-DevOps-Project)](https://github.com/mrbalraj007/Amazon-Prime-Clone-Project.git)


- [x] __Azure Account__: You’ll need an Azure account to create resources like virtual Machine, AKS cluster, and more.
- [x] __Terraform Knowledge__: Familiarity with Terraform to provision, manage, and clean up infrastructure.
- [x] __Basic Kubernetes (AKS)__: A basic understanding of Kubernetes, especially Azure AKS, to deploy and manage containers.
- [x] __Docker Knowledge__: Basic knowledge of Docker for containerizing applications.
- [x] __GitHub__: Experience with GitHub for version control and managing repositories.
- [x] __Command-Line Tools__: Basic comfort with using the command line for managing infrastructure and services.

## <span style="color: Yellow;">Setting Up the Infrastructure </span>

I have created a Terraform code to set up the entire infrastructure, including the installation of required applications, tools, and the AKS cluster automatically created.

**Note** &rArr;<span style="color: Green;"> ```AKS cluster``` creation will take approx. 10 to 15 minutes.

- &rArr; <span style="color: brown;">Virtual machines will be created named as ```"devopsdemovm"```

- &rArr;<span style="color: brown;"> Docker Install
- &rArr;<span style="color: brown;"> Azure Cli Install
- &rArr;<span style="color: brown;"> Terraform Install
- &rArr;<span style="color: brown;"> EKS Cluster Setup

### <span style="color: Yellow;"> Virtual Machine creation

First, we'll create the necessary virtual machines using ```terraform``` code. 

Below is a terraform Code:

Once you [clone repo](https://github.com/mrbalraj007/DevOps_free_Bootcamp.git) then go to folder *<span style="color: cyan;">"19.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box"</span>* and run the terraform command.
```bash
cd Terraform_Code/Code_IAC_Terraform_box

$ ls -l
dar--l          13/12/24  11:23 AM                All_Pipelines
dar--l          12/12/24   4:38 PM                k8s_setup_file
dar--l          11/12/24   2:48 PM                scripts
-a---l          11/12/24   2:47 PM            507 .gitignore
-a---l          13/12/24   9:00 AM           7238 main.tf
-a---l          11/12/24   2:47 PM           8828 main.txt
-a---l          11/12/24   2:47 PM           1674 MYLABKEY.pem
-a---l          11/12/24   2:47 PM            438 variables.tf
```

__<span style="color: Red;">Note__</span> &rArr; Make sure to run ```main.tf``` from inside the folders.

```bash
19.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box/

dar--l          13/12/24  11:23 AM                All_Pipelines
dar--l          12/12/24   4:38 PM                k8s_setup_file
dar--l          11/12/24   2:48 PM                scripts
-a---l          11/12/24   2:47 PM            507 .gitignore
-a---l          13/12/24   9:00 AM           7238 main.tf
-a---l          11/12/24   2:47 PM           8828 main.txt
-a---l          11/12/24   2:47 PM           1674 MYLABKEY.pem
-a---l          11/12/24   2:47 PM            438 variables.tf
```
You need to run ```main.tf``` file using following terraform command.

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
Once connected to EC2 instance then you can check the status of the ```user_data``` script by inspecting the [log files](https://github.com/mrbalraj007/DevOps_free_Bootcamp/blob/main/19.Real-Time-DevOps-Project/cloud-init-output.log).
```bash
# Primary log file for cloud-init
sudo tail -f /var/log/cloud-init-output.log
                    or 
sudo cat /var/log/cloud-init-output.log | more
```
- *If the user_data script runs successfully, you will see output logs and any errors encountered during execution.*
- *If there’s an error, this log will provide clues about what failed.*

Outcome of "```cloud-init-output.log```"

- From Terraform:
![image-2](https://github.com/user-attachments/assets/a1082c77-1607-4093-b8a7-41c94e358473)

### <span style="color: cyan;"> Verify the Installation 

- [x] <span style="color: brown;"> Docker version
```bash
ubuntu@ip-172-31-95-197:~$ docker --version
Docker version 24.0.7, build 24.0.7-0ubuntu4.1


docker ps -a
ubuntu@ip-172-31-94-25:~$ docker ps
```

- [x] <span style="color: brown;"> trivy version
```bash
ubuntu@ip-172-31-89-97:~$ trivy version
Version: 0.55.2
```
- [x] <span style="color: brown;"> Helm version
```bash
ubuntu@ip-172-31-89-97:~$ helm version
version.BuildInfo{Version:"v3.16.1", GitCommit:"5a5449dc42be07001fd5771d56429132984ab3ab", GitTreeState:"clean", GoVersion:"go1.22.7"}
```
- [x] <span style="color: brown;"> Terraform version
```bash
ubuntu@ip-172-31-89-97:~$ terraform version
Terraform v1.9.6
on linux_amd64
```
- [x] <span style="color: brown;"> eksctl version
```bash
ubuntu@ip-172-31-89-97:~$ eksctl version
0.191.0
```
- [x] <span style="color: brown;"> kubectl version
```bash
ubuntu@ip-172-31-89-97:~$ kubectl version
Client Version: v1.31.1
Kustomize Version: v5.4.2
```
- [x] <span style="color: brown;"> aws cli version
```bash
ubuntu@ip-172-31-89-97:~$ aws version
usage: aws [options] <command> <subcommand> [<subcommand> ...] [parameters]
To see help text, you can run:
  aws help
  aws <command> help
  aws <command> <subcommand> help
  
```

- [x] <span style="color: brown;"> Verify the EKS cluster

On the ```jenkins``` virtual machine, Go to directory ```k8s_setup_file``` and open the file ```cat apply.log``` to verify the cluster is created or not.
```sh
ubuntu@ip-172-31-90-126:~/k8s_setup_file$ pwd
/home/ubuntu/k8s_setup_file
ubuntu@ip-172-31-90-126:~/k8s_setup_file$ cd ..
kubectl version --client --output=yaml
```

After Terraform deploys on the instance, now it's time to setup the cluster. You can SSH into the instance and run:

```bash
aws eks update-kubeconfig --name <cluster-name> --region 
<region>
```
Once EKS cluster is setup then need to run the following command to make it intract with EKS.

```sh
aws eks update-kubeconfig --name balraj-cluster --region us-east-1
```
*The ```aws eks update-kubeconfig``` command is used to configure your local kubectl tool to interact with an Amazon EKS (Elastic Kubernetes Service) cluster. It updates or creates a kubeconfig file that contains the necessary authentication information to allow kubectl to communicate with your specified EKS cluster.*

<span style="color: Orange;"> What happens when you run this command:</span><br>
The AWS CLI retrieves the required connection information for the EKS cluster (such as the API server endpoint and certificate) and updates the kubeconfig file located at ```~/.kube/config (by default)```.
It configures the authentication details needed to connect kubectl to your EKS cluster using IAM roles.
After running this command, you will be able to interact with your EKS cluster using kubectl commands, such as ```kubectl get nodes``` or ```kubectl get pods```.

```sh
kubectl get nodes
kubectl cluster-info
kubectl config get-contexts
```
![image-3](https://github.com/user-attachments/assets/4818cf2e-c970-4309-96e3-84d3a7ccd7a7)

*******************************
- Created Instance and registry using terraform
- Open the portal ```https://dev.azure.com/<name>```
- create a new project
- URL: https://github.com/mrbalraj007/k8s-kind-voting-app.git
  - Original Repo; https://github.com/dockersamples/example-voting-app
- Create a repo :: 
- click on Imort a repository
![alt text](image.png)
![alt text](image-1.png)

![alt text](image-2.png)

![alt text](image-3.png)

![alt text](image-4.png)
![alt text](image-5.png)

![alt text](image-6.png)
it will asking you to login with you azure login. please use the same login crednetial which you have configure for azure portal login.

Select the container registry
![alt text](image-7.png)


- Key concept overview.
![alt text](image-9.png)

you will see the following pipeline yaml and we have to modify accordingly.
![alt text](image-8.png)

Paste the Updated_CI_Pipeline here.

- Also, we will create a folder named scripts and create a new sh file nameded as below and also use updated the container registroty name in the script file.
![alt text](image-23.png)



- Now, we will create a shell script to get an updated image tag in case if it is creating new image.

- First we will create a folder in repo called 'scripts' and update the sh file as below.
![alt text](image-54.png)
![alt text](image-55.png)
![alt text](image-56.png)


got below error message
![alt text](image-10.png)

Solution:
- Need to [integrate](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/linux-agent?view=azure-devops) to azure DevOps

![alt text](image-11.png)

![alt text](image-12.png)

![alt text](image-13.png)
![alt text](image-14.png)

Select the agent pools 
- devops-demo_vm 
![alt text](image-15.png)

![alt text](image-16.png)

run the following command to install the agent.
```sh
mkdir myagent && cd myagent

sudo wget https://vstsagentpackage.azureedge.net/agent/4.248.0/vsts-agent-linux-x64-4.248.0.tar.gz

tar zxvf vsts-agent-linux-x64-4.248.0.tar.gz
```

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

Configure the agent
```powershell
~/myagent$ ./config.sh

Type 'Y'

#Server URL
Azure Pipelines: https://dev.azure.com/{your-organization}
https://dev.azure.com/mrbalraj


```
Need to create a PAT access Token- 

- go to azure devops user setting and click on PAT.

![alt text](image-17.png)

![alt text](image-18.png)

![alt text](image-19.png)



devops-demo_vm

![alt text](image-20.png)

agent is still offline.
![alt text](image-21.png)


we have to Optionally run the agent interactively. If you didn't run as a service above:
```powershell
~/myagent$ ./run.sh
```
Now, Agent is online ;-)

![alt text](image-22.png)

rerun the pipeline and it works.
![alt text](image-68.png)


- rename the pipeline
![alt text](image-24.png)

### will create two more pipeline (microservices).

![alt text](image-25.png)

![alt text](image-26.png)


![alt text](image-27.png)


![alt text](image-28.png)

![alt text](image-29.png)

Next Steps:

- K8s Cluster login
- Argocd install
- Configure Argocd 
- Update shell - (Repo)


- Go Azure UI and select the AKS cluster 
![alt text](image-69.png)

![alt text](image-70.png)
![alt text](image-71.png)

Take putty session of Azure VM and perform the following instruction to login into auzre and K8s


### Azure login
Missing Browser on Headless Servers, Use the --use-device-code flag to authenticate without a browser:
```
az login --use-device-code
```
![alt text](image-30.png)

- https://microsoft.com/devicelogin access this URL in a new browser and type the code which you see in console.
- ![alt text](image-31.png)

![alt text](image-32.png)

```sh
az account list --output table
```
![alt text](image-33.png)





- To get resource details
```sh
az aks list --resource-group "resourceGroupName" --output table
```
![alt text](image-34.png)

![alt text](image-35.png)

- To get credentails for AKS
```sh
az aks get-credentials --name "Clustername" --resource-group "ResourceGroupName" --overwrite-existing

kubectl config current-context
kubectl get nodes
kubectl get nodes -o wide
```
![alt text](image-36.png)

### <span style="color: orange;"> Install ArgoCD
```sh
kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### <span style="color: orange;"> Setup ArgoCD </span>

- Run the following commands to verify the ```Pods``` and ```services type```

```sh
kubectl get pods -n argocd
kubectl get svc -n argocd
```

- To get details of Pods in namespace "argocd"
```sh
kubectl get pods -n argocd
```
![alt text](image-37.png)

- To get the secrets for argoCd
```sh
kubectl get secrets -n argocd
```
![alt text](image-38.png)

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
![alt text](image-40.png)

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
![alt text](image-41.png)

- To get URL/IP address details
```sh
kubectl get nodes -o wide
```
```sh
azureuser@devopsdemovm:~/myagent$ kubectl get nodes -o wide
NAME                                STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
aks-agentpool-23873620-vmss000000   Ready    <none>   54m   v1.30.6   10.224.0.4    <none>        Ubuntu 22.04.5 LTS   5.15.0-1075-azure   containerd://1.7.23-1
```
![alt text](image-42.png)

<!-- - Currently, it is set to ```NodePort``` and we will change it to ```LoadBalancer```
- Expose Argo CD server using NodePort:
```sh
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
``` -->

Verify Kubernetes Config: Confirm that the argocd-server service has the correct ```NodePort``` and is not misconfigured:

```bash
kubectl describe svc argocd-server -n argocd
```
```sh
azureuser@devopsdemovm:~$ kubectl get svc -n argocd
NAME                                      TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                      AGE
argocd-applicationset-controller          ClusterIP   10.0.98.49    <none>        7000/TCP,8080/TCP            2m31s
argocd-dex-server                         ClusterIP   10.0.130.97   <none>        5556/TCP,5557/TCP,5558/TCP   2m31s
argocd-metrics                            ClusterIP   10.0.91.113   <none>        8082/TCP                     2m31s
argocd-notifications-controller-metrics   ClusterIP   10.0.83.161   <none>        9001/TCP                     2m31s
argocd-redis                              ClusterIP   10.0.241.99   <none>        6379/TCP                     2m31s
argocd-repo-server                        ClusterIP   10.0.38.142   <none>        8081/TCP,8084/TCP            2m31s
argocd-server                             NodePort    10.0.228.33   <none>        80:32648/TCP,443:31181/TCP   2m31s
argocd-server-metrics                     ClusterIP   10.0.124.90   <none>        8083/TCP                     2m31s

azureuser@devopsdemovm:~$ kubectl get nodes -o wide
NAME                             STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP     OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
aks-system-29381837-vmss000000   Ready    <none>   26m   v1.30.6   10.224.0.4    52.148.171.58   Ubuntu 22.04.5 LTS   5.15.0-1075-azure   containerd://1.7.23-1
```
Then access it at ```http://52.148.171.58:32648```.

If page is not opening then we have to open a port in NSG.
- On Azure portal server with ```VMSS``` and select the ```VMSS```
![alt text](image-72.png)
![alt text](image-74.png)
![alt text](image-75.png)
![alt text](image-76.png)
![alt text](image-77.png)

Now, we need to try to access it again ```http://52.148.171.58:32648```.
![alt text](image-78.png)

- To retrive the password for argocd
```sh
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
![alt text](image-39.png)

#### <span style="color: orange;"> To configure repo in argocd with token base.
```sh
(http://52.148.171.58:32648)
```
![alt text](image-44.png)


Go to azure pipeline and clink on setting and select "Personal Access Token"
![alt text](image-45.png)
![alt text](image-46.png)


![alt text](image-47.png)
![alt text](image-48.png)

```sh
https://<Accesstoken>@dev.azure.com/mrbalraj/balraj-devops/_git/balraj-devops
```
![alt text](image-49.png)


#### <span style="color: orange;"> To create a application in argocd
Once you access the ArgoCD URL and create an application
 - **Application Name**: voteaccess-service
 - **Project Name**: default
 - **Sync Policy**: Automatic (Select Prune Resources and SelfHeal)
 - **Repository URL**: https://mrbalraj@dev.azure.com/mrbalraj/balraj-devops/_git/balraj-devops
 - **Revison**: main
 - **Path**:  k8s-specifications (where Kubernetes files reside)
 - **cluster URL**: Select default cluster
 - **Namespace**: default

![alt text](image-50.png)
![alt text](image-51.png)

by default 3 min to sync with argocd but it can be changed.

![alt text](image-52.png)

![alt text](image-53.png)



Now, we will update our pipeline as below- 


- Now, we will change the argocd default time (3 min) to 10 sec.

```sh
kubectl edit cm argocd-cm -n argocd
```
edit as below
![alt text](image-57.png)

Now, try to get all resouces and you will noticed there is an error related to "ImagePullBackoff".

```sh
kubectl get all
```
I am getting below error message.
![alt text](image-58.png)
![alt text](image-59.png)

**Solution**: As we are using private registory and we need to use 'imagepullsecrets'

Go to azure registory and get the password which will be used in below command
![alt text](image-60.png)


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
![alt text](image-79.png)

```sh
kubectl create secret docker-registry acr-credentials \
    --namespace default \
    --docker-server=aconregee7b05ba.azurecr.io \
    --docker-username=aconregee7b05ba \
    --docker-password=<token>
```
![alt text](image-61.png)

- Command to delete ```secret```
 ```sh
kubectl delete secret acr-credential --namespace default
 ``` 

now, we will update the vote-deployment.yaml as below:
![alt text](image-62.png)

Need to update in all other deployment as below:

![alt text](image-43.png)
![alt text](image-73.png)


here is the updated stats

![alt text](image-63.png)


Try to update anything at vote folder in ```"app.py"``` as below and pipeline should be auto triggered.

![alt text](image-64.png)
![alt text](image-65.png)

To check the deployment
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
![alt text](image-66.png)


Vote application is accessible now.
![alt text](image-80.png)
![alt text](image-81.png)

Congratulations :-) the application is working and accessible.















### <span style="color: yellow;"> Cleanup the images and deployment using the pipeline.</span>




## <span style="color: Yellow;"> Environment Cleanup:
- As we are using Terraform, we will use the following command to delete 

- __Delete all deployment/Service__ first
    - ```sh
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
        ```
![alt text](image-67.png)


#### Now, time to delete the ```AKS Cluster and Virtual machine```.
Go to folder *<span style="color: cyan;">"19.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box"</span>* and run the terraform command.
```bash
cd Terraform_Code/

$ ls -l
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
da---l          26/09/24   9:48 AM                Code_IAC_Terraform_box

Terraform destroy --auto-approve
```

## <span style="color: Yellow;"> Conclusion

Migrating CI pipelines from GitHub to Azure DevOps can significantly improve your development process by automating the build and deployment stages. This blog covered the step-by-step process of setting up an Azure DevOps pipeline to build Docker images and push them to Azure Container Registry. It also provided insights into handling pipeline triggers for different microservices, ensuring that the correct pipelines run when changes are made. By adopting this approach, you’ll streamline your CI workflows and enhance your development productivity.


__Ref Link:__


[CI-Pipeline](https://www.youtube.com/watch?v=aAjH9wqtx9o&list=PLdpzxOOAlwvIcxgCUyBHVOcWs0Krjx9xR&index=15)

[CD-Pipeline](https://www.youtube.com/watch?v=HyTIsLZWkZg&list=PLdpzxOOAlwvIcxgCUyBHVOcWs0Krjx9xR&index=16)

[Create an Account in Azure DevOps](https://www.youtube.com/watch?v=A91difri0BQ)


- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

- [Install AWS Cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-terraform?pivots=development-environment-azure-cli

https://developer.hashicorp.com/terraform/tutorials/kubernetes/aks

https://stacksimplify.com/azure-aks/create-aks-cluster-using-terraform/

https://argo-cd.readthedocs.io/en/stable/operator-manual/upgrading/2.0-2.1/#replacing-app-resync-flag-with-timeoutreconciliation-setting

https://argo-cd.readthedocs.io/en/stable/

https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/