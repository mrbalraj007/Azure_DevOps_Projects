```sh
# Docker
# Build and push an image to Azure Container Registry
# https://docs.microsoft.com/azure/devops/pipelines/languages/docker

trigger:
 paths:
   include:
     - worker/*

resources:
- repo: self

variables:
  # Container registry service connection established during pipeline creation
  dockerRegistryServiceConnection: '7cdfda81-29df-400f-a9ca-0c448ab6f4e4'
  imageRepository: 'worker-app'
  containerRegistry: 'aconregaaaf0e8c.azurecr.io'
  dockerfilePath: '$(Build.SourcesDirectory)/worker111/Dockerfile'
  tag: '$(Build.BuildId)'

  # Agent VM image name
  # vmImageName: 'ubuntu-latest'   

  # Here you need to update your virtual machine name as it would be treated as agent to run your pipeline.
pool:
 name: 'devops-demo_vm'

stages:
- stage: Build
  displayName: Build the image
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
        Dockerfile: 'worker/Dockerfile'
        tags: '$(tag)'
- stage: Push
  displayName: Push the image
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