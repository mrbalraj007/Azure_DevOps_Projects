```sh
# Docker
# Build and push an image to Azure Container Registry
# https://docs.microsoft.com/azure/devops/pipelines/languages/docker

trigger:
- main

resources:
- repo: self


variables:
  # Container registry service connection established during pipeline creation
  dockerRegistryServiceConnection: 'acrconnection'
  imageRepository: 'pythonappdocker'
  containerRegistry: 'mypythonacr31098'
  dockerfilePath: '$(Build.SourcesDirectory)/Dockerfile'
  tag: '$(Build.BuildId)'
  #tag: 'latest'

pool:
  name: Terraform-agent-pool

stages:
- stage: Build
  displayName: Build and push stage
  jobs:
  - job: Build
    displayName: Build
    steps:
    - task: Docker@2
      displayName: Build and push an image to container registry
      inputs:
        containerRegistry: 'azureConReg'
        repository: '$(imageRepository)'
        command: 'buildAndPush'
        Dockerfile: '**/Dockerfile'
        tags: '$(tag)'
    - task: ArchiveFiles@2
      inputs:
        rootFolderOrFile: '$(Build.SourcesDirectory)'
        includeRootFolder: false
        archiveType: 'zip'
        archiveFile: '$(Build.ArtifactStagingDirectory)/$(Build.BuildId).zip'
        replaceExistingArchive: true
    - task: CopyPublishBuildArtifacts@1
      inputs:
        CopyRoot: '$(Build.ArtifactStagingDirectory)'
        Contents: '**'
        ArtifactName: 'drop'
        ArtifactType: 'Container'
```