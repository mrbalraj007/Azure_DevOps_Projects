```sh
# Docker
# Build and push an image to Azure Container Registry
# https://docs.microsoft.com/azure/devops/pipelines/languages/docker

trigger:
#- master
- none

resources:
- repo: self

variables:
  # Container registry service connection established during pipeline creation
  dockerRegistryServiceConnection: '38d3e71c-6619-4f5a-be4c-cde394933a53'
  imageRepository: 'secretsanta-generator'
  containerRegistry: 'aconreg6700da08.azurecr.io'
  dockerfilePath: '$(Build.SourcesDirectory)/Dockerfile'
  tag: '$(Build.BuildId)'

pool:
  name: devops-demo_vm
  demands: agent.name -equals agent-1

# To compile the package.
stages:
- stage: CompileJob
  displayName: 'Compile Stage'
  jobs:
  - job: CompileJob
    displayName: 'Compile Job'
    steps:
    - script: mvn compile
      displayName: 'Compile Step'

# To test the package
- stage: Test
  displayName: 'Test Stage'
  jobs:
  - job: TestJob
    displayName: 'Test Job'
    steps:
    - script: mvn test
      displayName: 'Test Step'

# To scan the file System
- stage: Trivy_FS_Scan
  displayName: 'Trivy-FS-Stage'
  jobs:
  - job: TrivyFSJob
    displayName: 'TrivyFSJob'
    steps:
    - script: trivy fs --format table -o trivy-fs-report.html .
      displayName: 'TrivyFS-Scan_Step'

# To SonarQube   
- stage: SonarQube_Scan
  displayName: 'SonarQube-Stage'
  jobs:
  - job: SonarQubeSJob
    displayName: 'SonarQubeJob'
    steps:
    - task: SonarQubePrepare@7
      inputs:
        SonarQube: 'sonar-conn'
        scannerMode: 'cli'
        configMode: 'manual'
        cliProjectKey: 'secretsanta'
        cliProjectName: 'secretsanta'
        cliSources: '.'
        extraProperties: 'sonar.java.binaries=.'
    - task: SonarQubeAnalyze@7
      inputs:
        jdkversion: 'JAVA_HOME'

# To build the Package.
- stage: Build
  displayName: 'Build-Stage'
  jobs:
  - job: BuildJob
    displayName: 'BuildJob'
    steps:
    - script: mvn package
      displayName: 'Build_package_Step'

# To Build and Push an Image.
- stage: Docker_Build
  displayName: Build and push stage
  jobs:
  - job: Build
    displayName: Build
    steps:
    - script: mvn package
      displayName: 'Build_package_Step'
    - task: Docker@2
      displayName: Build and push an image to container registry
      inputs:
        containerRegistry: '$(dockerRegistryServiceConnection)'   #'aconreg6700da08'
        repository: '$(imageRepository)'
        command: 'buildAndPush'
        Dockerfile: '**/Dockerfile'
        tags: '$(tag)'

# To Update the manifest file
- stage: Update_Manifest_file
  displayName: Update_Manifest_file
  jobs:
  - job: Update
    displayName: Update_Manifest_file
    steps:
    - script: |
        sudo apt-get update
        sudo apt-get install dos2unix -y
        dos2unix 'scripts/updateK8sManifests.sh'
      displayName: 'Install pkgs'
    - task: ShellScript@2
      inputs:  
        scriptPath: 'scripts/updateK8sManifests.sh'
        args: '$(containerRegistry) $(imageRepository) $(tag) Service-deployment'

# To scan the image
- stage: Trivy_Image_Scan
  displayName: 'Trivy-Image-Stage'
  jobs:
  - job: TrivyImageJob
    displayName: 'TrivyImageJob'
    steps:
    - script: trivy image --format table -o trivy-image-report.html $(containerRegistry)/$(imageRepository):$(tag)
      displayName: 'TrivyImage-Scan_Step'

# To Deploy the image
- stage: K8_Deploy
  displayName: 'K8_Deploy_Stage'
  jobs:
  - job: K8s_Deploy_Job
    displayName: 'K8s_Deploy_Job'
    steps:
    - task: KubectlInstaller@0
      inputs:
        kubectlVersion: 'latest'
    - task: Kubernetes@1
      inputs:
        connectionType: 'Kubernetes Service Connection'
        kubernetesServiceEndpoint: 'k8s-conn'
        namespace: 'default'
        command: 'apply'
        useConfigurationFile: true
        configuration: 'k8s-specifications/Service-deployment.yaml'
```