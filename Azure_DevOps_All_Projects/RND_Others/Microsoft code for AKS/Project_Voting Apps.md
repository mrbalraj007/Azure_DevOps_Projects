# <span style="color: Yellow;">Automated AWS DevOps CI/CD Pipeline for Amazon Prime Clone</span>

In today’s fast-paced tech world, automating application deployment and infrastructure management is crucial. This project demonstrates how to set up a complete CI/CD pipeline, use AWS EKS for Kubernetes deployment, and integrate Grafana and Prometheus for monitoring, all using Terraform for infrastructure management. By automating everything, you reduce the need for manual intervention and improve the speed and reliability of your deployments.

## <span style="color: Yellow;">Prerequisites</span>

Before diving into this project, here are some skills and tools you should be familiar with:

- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/DevOps_free_Bootcamp/tree/main/19.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box)
  - Replace resource names and variables as per your requirement in terraform code.
- [x] [App Repo (Simple-DevOps-Project)](https://github.com/mrbalraj007/Amazon-Prime-Clone-Project.git)
- [x] __AWS Account__: Required for creating resources like EC2 instances, EKS clusters, and more.
- [x] __Terraform Knowledge__: Familiarity with Terraform to provision, manage, and clean up infrastructure.
- [x] __Basic Kubernetes (EKS)__: Understanding of Kubernetes, especially Amazon EKS.
- [x] __Docker Knowledge__: Basic knowledge of Docker for containerizing applications.
- [x] __Grafana & Prometheus__: Understanding of these tools for monitoring applications.
- [x] __Jenkins__: Knowledge of Jenkins for building and automating the CI/CD pipeline.
- [x] __GitHub__: Experience with GitHub for version control and managing repositories.
- [x] __Command-Line Tools__: Basic comfort with using the command line for managing infrastructure and services.

## <span style="color: Yellow;">Setting Up the Infrastructure</span>

I have created a Terraform code to set up the entire infrastructure, including the installation of required applications, tools, and the EKS cluster automatically created.

**Note**: <span style="color: Green;">AKS cluster creation will take approx. 10 to 15 minutes.</span>

### <span style="color: Yellow;">EC2 Instances Creation</span>

First, we'll create the necessary virtual machines using Terraform code. 

Clone the repo and navigate to the Terraform code directory:
```bash
cd Terraform_Code/Code_IAC_Terraform_box
```

Run the following Terraform commands:
```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply 
# Optional: terraform apply --auto-approve
```

### <span style="color: Orange;">Inspect the Cloud-Init Logs</span>

Once connected to the EC2 instance, check the status of the `user_data` script by inspecting the log files:
```bash
sudo tail -f /var/log/cloud-init-output.log
# or
sudo cat /var/log/cloud-init-output.log | more
```

### <span style="color: cyan;">Verify the Installation</span>

- **Docker version**
```bash
docker --version
docker ps -a
```
- **Trivy version**
```bash
trivy version
```
- **Helm version**
```bash
helm version
```
- **Terraform version**
```bash
terraform version
```
- **eksctl version**
```bash
eksctl version
```
- **kubectl version**
```bash
kubectl version
```
- **AWS CLI version**
```bash
aws --version
```

### <span style="color: brown;">Verify the EKS Cluster</span>

On the Jenkins virtual machine, navigate to the `k8s_setup_file` directory and verify the cluster creation:
```bash
aws eks update-kubeconfig --name <cluster-name> --region <region>
kubectl get nodes
kubectl cluster-info
kubectl config get-contexts
```

### <span style="color: Yellow;">Setup Jenkins</span>

Access Jenkins via `http://<your-server-ip>:8080`. Retrieve the initial admin password:
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

#### <span style="color: cyan;">Install Plugins in Jenkins</span>
Manage Jenkins > Plugins view > Available tab:
- SonarQube Scanner
- NodeJS
- Pipeline: Stage View
- Blue Ocean
- Eclipse Temurin installer
- Docker
- Docker Commons
- Docker Pipeline
- Docker API
- docker-build-step
- Prometheus metrics

#### <span style="color: cyan;">Create Webhook in SonarQube</span>
- Administration > Configuration > Webhooks
  - **Name**: sonarqube-webhook
  - **URL**: `<publicIPaddressofJenkins:8080/sonarqube-webhook>`

#### <span style="color: cyan;">Create a Token in SonarQube</span>
- Administration > Security > Users > Create a new token

#### <span style="color: yellow;">Configure SonarQube Credential in Jenkins</span>
Dashboard > Manage Jenkins > Credentials > System > Global credentials (unrestricted)

#### <span style="color: yellow;">Configure AWS Credential in Jenkins</span>
Dashboard > Manage Jenkins > Credentials > System > Global credentials (unrestricted)

#### <span style="color: cyan;">Configure/Integrate SonarQube in Jenkins</span>
Dashboard > Manage Jenkins > System

#### <span style="color: cyan;">Configure JDK, Sonar Scanner, and Node JS</span>
Dashboard > Manage Jenkins > Tools

#### <span style="color: orange;">Build a Pipeline</span>
Here is the [Pipeline Script](https://github.com/mrbalraj007/DevOps_free_Bootcamp/blob/main/19.Real-Time-DevOps-Project/Terraform_Code/Code_IAC_Terraform_box/All_Pipelines/Pipeline_CI.md)

### <span style="color: orange;">Setup ArgoCD</span>

Run the following commands to verify the Pods and services type:
```bash
kubectl get pods -n argocd
kubectl get svc -n argocd
kubectl get pods -n prometheus
kubectl get service -n prometheus
```

Change the service type from `ClusterIP` to `LoadBalancer`:
```bash
kubectl patch svc stable-kube-prometheus-sta-prometheus -n prometheus -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc stable-grafana -n prometheus -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

Run the script to get ArgoCD and Grafana access details.

### <span style="color: yellow;">Environment Cleanup</span>

Delete all deployments and services first:
```bash
kubectl delete deployment.apps/singh-app
kubectl delete service singh-app
kubectl delete service/singh-service
```

Delete the EKS cluster:
```bash
cd /k8s_setup_file
sudo terraform destroy --auto-approve
```

Delete the virtual machine:
```bash
cd Terraform_Code/
terraform destroy --auto-approve
```

## <span style="color: Yellow;">Conclusion</span>

By combining Terraform, Jenkins, EKS, Docker, and monitoring tools like Grafana and Prometheus, this project automates the entire process of infrastructure management, application deployment, and monitoring. The use of a cleanup pipeline ensures that resources are removed when no longer needed, helping to reduce costs. This approach offers a scalable, efficient, and cost-effective solution for modern application deployment and management.

__Ref Links:__

- [CI-Pipeline](https://www.youtube.com/watch?v=aAjH9wqtx9o&list=PLdpzxOOAlwvIcxgCUyBHVOcWs0Krjx9xR&index=15)
- [CD-Pipeline](https://www.youtube.com/watch?v=HyTIsLZWkZg&list=PLdpzxOOAlwvIcxgCUyBHVOcWs0Krjx9xR&index=16)
- [Create an Account in Azure DevOps](https://www.youtube.com/watch?v=A91difri0BQ)
- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Azure AKS Quick Kubernetes Deploy Terraform](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-terraform?pivots=development-environment-azure-cli)
- [Create AKS Cluster Using Terraform](https://stacksimplify.com/azure-aks/create-aks-cluster-using-terraform/)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/en/stable/)
- [Kubernetes Pull Image Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)