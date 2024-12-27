```sh
# Docker
# Delete all images and repositories from Azure Container Registry
# https://docs.microsoft.com/azure/devops/pipelines/languages/docker

trigger:
 paths:
    include:
     - worker/*

resources:
- repo: self

variables:
  azureServiceConnection: '9e0f2ba2-e6e5-490c-8a9f-a2f8bbbc350f'
  containerRegistry: 'aconreg6fdbda3e.azurecr.io'
  imageRepository: 'worker-app'

pool:
 name: 'devops-demo_vm'

stages:
- stage: Delete
  displayName: Delete stage
  jobs:
  - job: Delete
    displayName: Delete
    steps:
    - task: AzureCLI@2
      inputs:
        azureSubscription: '$(azureServiceConnection)'
        scriptType: 'bash'
        scriptLocation: 'inlineScript'
        inlineScript: |
          az acr login --name $(containerRegistry)
    - script: |
        az acr repository show-tags --name $(containerRegistry) --repository $(imageRepository) --output tsv | xargs -I % az acr repository delete --name $(containerRegistry) --image $(imageRepository):% --yes
      displayName: 'Delete all images and tags from repository'
    - script: |
        az acr repository delete --name $(containerRegistry) --repository $(imageRepository) --yes || echo "Repository already deleted"
      displayName: 'Delete repository'
```
