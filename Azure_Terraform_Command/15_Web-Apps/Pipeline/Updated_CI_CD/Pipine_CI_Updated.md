# Docker
# Build and push an image to Azure Container Registry
# https://docs.microsoft.com/azure/devops/pipelines/languages/docker

trigger:
  - none
  
resources:
  - repo: self
  
variables:
    # Container registry service connection established during pipeline creation
    dockerRegistryServiceConnection: '79c16dd0-84c2-43f3-bf54-2f6b2361862e'
    imageRepository: 'multitierwithdatabase'
    containerRegistry: 'aconreg6700da08.azurecr.io'
    dockerfilePath: '$(Build.SourcesDirectory)/Dockerfile'
    # tag: '$(Build.BuildId)'
    tag: 'latest'
  
pool:
    name: devops-demo_vm
    demands: agent.name -equals agent-1
  
stages:
  # Add Compiling.
    - stage: CompileJob
      displayName: 'Maven Compile'
      jobs:
      - job: maven_compile
        displayName: 'maven_compile'
        steps:
        - task: Maven@4
          inputs:
            azureSubscription: 'azure-conn'
            mavenPomFile: 'pom.xml'
            goals: 'compile'
            publishJUnitResults: true
            testResultsFiles: '**/surefire-reports/TEST-*.xml'
            javaHomeOption: 'JDKVersion'
            mavenVersionOption: 'Default'
            mavenAuthenticateFeed: false
            effectivePomSkip: false
            sonarQubeRunAnalysis: false
  
  # Add Testing
    - stage: Test
      displayName: 'Maven Test'
      jobs:
        - job: maven_test
          displayName: 'Unit_Test'
          steps:
            - task: Maven@4
              inputs:
                azureSubscription: 'azure-conn'
                mavenPomFile: 'pom.xml'
                goals: 'test'
                publishJUnitResults: true
                testResultsFiles: '**/surefire-reports/TEST-*.xml'
                javaHomeOption: 'JDKVersion'
                mavenVersionOption: 'Default'
                mavenAuthenticateFeed: false
                effectivePomSkip: false
                sonarQubeRunAnalysis: false
  
  # Add Trivy FS scan image.  
    - stage: Trivy_FS_Scan
      displayName: 'Trivy_FS_Scan'
      jobs:
        - job: Trivy_FS_Scan
          displayName: 'Trivy FS Scan'       
          steps:
            - task: CmdLine@2
              inputs:
                script: 'trivy fs --format table -o trivy-fs-report.html .'
  
  # Add SonarQube  
    - stage: SonarQube
      displayName: 'SonarAnalysis'
      jobs:
        - job: SonarQube_analysis
          steps:
            - task: SonarQubePrepare@7
              inputs:
                SonarQube: 'sonar-conn'
                scannerMode: 'cli'
                configMode: 'manual'
                cliProjectKey: 'bankapp'
                cliProjectName: 'bankapp'
                cliSources: '.'
                extraProperties: 'sonar.java.binaries=.' 
            - task: SonarQubeAnalyze@7
              inputs:
                jdkversion: 'JAVA_HOME_17_X64'
  
  # To Publish the Artifacts.
    - stage: Publish_Artifact
      displayName: 'Publish_Build_Artifacts'
      jobs:
        - job: publish_artifacts
          displayName: 'Publish_build_Artifacts'
          steps:
            - task: MavenAuthenticate@0
              inputs:
                artifactsFeeds: 'store_artifact-maven'
            - task: Maven@4
              inputs:
                azureSubscription: 'azure-conn'
                mavenPomFile: 'pom.xml'
                goals: 'deploy'
                publishJUnitResults: true
                testResultsFiles: '**/surefire-reports/TEST-*.xml'
                javaHomeOption: 'JDKVersion'
                mavenVersionOption: 'Default'
                mavenAuthenticateFeed: false
                effectivePomSkip: false
                sonarQubeRunAnalysis: false
  
  # To Docker image build 
    - stage: Docker_Build          
      displayName: 'Docker_Build'
      jobs:
        - job: docker_build
          displayName: 'docker_build'
          steps:
            - task: CmdLine@2
              inputs:
                script: 'mvn package'
            - task: Docker@2
              inputs:
                 containerRegistry: '$(dockerRegistryServiceConnection)'   #'aconreg6700da08'
                 repository: '$(imageRepository)'
                 command: 'build'
                 Dockerfile: '**/Dockerfile'
                 tags: '$(tag)'
    # Add Trivy Image scan .  
    - stage: Trivy_image_Scan
      displayName: 'Trivy_image_Scan'
      jobs:
        - job: Trivy_image_Scan
          displayName: 'Trivy image Scan'       
          steps:
            - task: CmdLine@2
              inputs:
                script: 'trivy image --format table -o trivy-image-report.html $(containerRegistry)/$(imageRepository):$(tag)'
  
  # To Docker push Image
    - stage: Docker_Publish          
      displayName: 'Docker_Publish'
      jobs:
        - job: docker_Publish
          displayName: 'docker_Publish'
          steps:
            - task: Docker@2
              inputs:
                containerRegistry: '$(dockerRegistryServiceConnection)'   #'aconreg6700da08'
                repository: '$(imageRepository)'
                command: 'push'
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
    
    # To Deploy on K8s
    
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