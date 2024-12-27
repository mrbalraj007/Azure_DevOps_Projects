```sh
# Docker
# Build and push an image to Azure Container Registry
# https://docs.microsoft.com/azure/devops/pipelines/languages/docker

trigger:
 paths:
    include:
     - result/*

resources:
- repo: self

variables:
  # Container registry service connection established during pipeline creation
  dockerRegistryServiceConnection: '5e4b7ab7-2ac7-46a2-bf0f-beceb6ddad1f'
  imageRepository: 'result-app'
  containerRegistry: 'aconreg603c1026.azurecr.io'
  dockerfilePath: '$(Build.SourcesDirectory)/result/Dockerfile'
  tag: '$(Build.BuildId)'

  # Agent VM image name
  # vmImageName: 'ubuntu-latest'   

  # Here you need to update your virtual machine name as it would be treated as agent to run your pipeline.
pool:
 name: 'devops-demo_vm'

stages:
- stage: Build
  displayName: Build stage
  jobs:
  - job: Build
    displayName: Build
    steps:
    - task: Docker@2
      displayName: Build the image
      inputs:
        containerRegistry: '$(dockerRegistryServiceConnection)'
        repository: '$(imageRepository)'
        command: 'build'
        Dockerfile: 'result/Dockerfile'
        tags: '$(tag)'
- stage: Push
  displayName: Push stage
  jobs:
  - job: Push
    displayName: Push
    steps:
    - task: Docker@2
      displayName: Push the image
      inputs:
        containerRegistry: '$(dockerRegistryServiceConnection)'
        repository: '$(imageRepository)'
        command: 'push'
        tags: '$(tag)'
- stage: Update
  displayName: Update
  jobs:
  - job: Update
    displayName: Update
    steps:
    - script: |
        sudo apt-get update
        sudo apt-get install dos2unix -y
        dos2unix 'scripts/updateK8sManifests.sh'
      displayName: 'Install pkgs'
    - task: ShellScript@2
      inputs:  
        scriptPath: 'scripts/updateK8sManifests.sh'
        args: 'result $(imageRepository) $(tag)'
```