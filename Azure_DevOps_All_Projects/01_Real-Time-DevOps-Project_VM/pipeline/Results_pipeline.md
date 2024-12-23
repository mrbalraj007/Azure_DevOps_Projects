```sh
# Docker
# Build and push an image to Azure Container Registry
# https://docs.microsoft.com/azure/devops/pipelines/languages/docker

trigger:
 paths:
    include:
     - results/*

resources:
- repo: self

variables:
  # Container registry service connection established during pipeline creation
  dockerRegistryServiceConnection: '58ff46b5-f307-431e-a6fa-fd6a7f8ebd22'
  imageRepository: 'result-app'
  containerRegistry: 'aconregaaaf0e8c.azurecr.io'
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
```