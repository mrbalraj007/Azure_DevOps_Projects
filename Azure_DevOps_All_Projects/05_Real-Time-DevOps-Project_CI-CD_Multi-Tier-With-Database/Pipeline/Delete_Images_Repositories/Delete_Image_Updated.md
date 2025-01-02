```sh
# Docker
# Delete all images and repositories from Azure Container Registry
# https://docs.microsoft.com/azure/devops/pipelines/languages/docker

trigger:
- none


resources:
- repo: self

variables:
  azureServiceConnection: 'your Service Connection_ID'
  containerRegistry: 'aconreg05a01096.azurecr.io'
  imageRepository: 'dev'

pool:
  name: devops-demo_vm
  demands: agent.name -equals agent-1

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
