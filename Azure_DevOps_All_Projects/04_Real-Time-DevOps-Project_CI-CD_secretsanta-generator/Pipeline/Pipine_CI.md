```sh
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger:
# master   
- none

pool:
  name: devops-demo_vm
  demands: agent.name -equals agent-1

stages:
- stage: CompileJob
  displayName: 'Compile Stage'
  jobs:
  - job: CompileJob
    displayName: 'Compile Job'
    steps:
    - script: mvn compile
      displayName: 'Compile Step'

- stage: Test
  displayName: 'Test Stage'
  jobs:
  - job: TestJob
    displayName: 'Test Job'
    steps:
    - script: mvn test
      displayName: 'Test Step'

- stage: Trivy_FS_Scan
  displayName: 'Trivy-FS-Stage'
  jobs:
  - job: TrivyFSJob
    displayName: 'TrivyFSJob'
    steps:
    - script: trivy fs --format table -o trivy-fs-report.html .
      displayName: 'TrivyFS-Scan_Step'

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

- stage: Build
  displayName: 'Build-Stage'
  jobs:
  - job: BuildJob
    displayName: 'BuildJob'
    steps:
    - script: mvn package
      displayName: 'Build_package_Step'

- stage: Docker
  displayName: 'Docker-Stage'
  jobs:
  - job: DockerJob
    displayName: 'Docker Job'
    steps:
    - script: mvn package
      displayName: 'Build_package_Step'
    - task: Docker@2
      inputs:
        containerRegistry: 'docker-conn'
        repository: 'balrajsi/secretsanta'
        command: 'buildAndPush'
        Dockerfile: '**/Dockerfile'
        tags: 'latest'

- stage: Trivy_Image_Scan
  displayName: 'Trivy-Image-Stage'
  jobs:
  - job: TrivyImageJob
    displayName: 'TrivyImageJob'
    steps:
    - script: trivy image --format table -o trivy-image-report.html balrajsi/secretsanta:latest
      displayName: 'TrivyImage-Scan_Step'

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
        configuration: 'deployment-service.yaml'
        secretType: 'dockerRegistry'
        containerRegistryType: 'Azure Container Registry'
        azureSubscriptionEndpointForSecrets: 'Free Trial(2fc598a4-6a52-44b9-b476-6a62640513f8)'
        azureContainerRegistry: 'aconreg6700da08.azurecr.io'
        forceUpdate: false
```