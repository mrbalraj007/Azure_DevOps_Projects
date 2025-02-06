```sh
# Docker
# Build a Docker image
# https://docs.microsoft.com/azure/devops/pipelines/languages/docker

trigger:
- none
resources:
- repo: self
variables:
  tag: '$(Build.BuildId)'
#pool:
 # Default
stages:
##############################################################################################################
- stage: Build_and_Push
  variables:
   - group: secrets
   - group: acr_variables
  jobs:
  - job: Build_and_Push_Job
    pool:
      name: Default
    steps:
    - checkout: self
    - script: |
        # Authenticate with Azure CLI
        az login --service-principal -u $(servicePrincipalId) -p $(servicePrincipalKey) --tenant $(tenantId)
        az acr login --name $(TF_VAR_PRIVATE_ACR_NAME)  # Replace with your ACR name
        # Build and push the Docker image to ACR
        docker build -t $(TF_VAR_PRIVATE_ACR_NAME).azurecr.io/$(build.repository.name)-$(Build.SourceBranchName):v1 .
        docker push $(TF_VAR_PRIVATE_ACR_NAME).azurecr.io/$(build.repository.name)-$(Build.SourceBranchName):v1
      displayName: 'Build and Push Docker Image'

- stage: Deploy_to_AKS
  variables:
    - group: secrets
  jobs:
  - deployment: Deploy_to_AKS_Job
    environment: 'AKS_Environment'
    pool:
      name: Default
    strategy:
      runOnce:
        deploy:
          steps:
          - checkout: self
          - script: |
              # Authenticate with Azure CLI
              az login --service-principal -u $(servicePrincipalId) -p $(servicePrincipalKey) --tenant $(tenantId)
              az aks get-credentials --resource-group rg-devops --name aksdemo --overwrite-existing
              # Deploy to AKS
              kubectl apply -f deployment.yaml
            displayName: 'Deploy to AKS'


```