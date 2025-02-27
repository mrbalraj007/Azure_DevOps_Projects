```sh
trigger:
- none

resources:
  pipelines:
  - pipeline: Terraform
    source: Terraform 
    trigger: true

pool:
  name: Default

steps:

  - task: DownloadPipelineArtifact@2
    displayName: "Download Build artifact to Agent"
    inputs:
      buildType: 'specific'
      project: 'baf3e36d-9b8e-494f-b305-8108ecbcc971'
      definition: '67'
      specificBuildWithTriggering: true
      buildVersionToDownload: 'latest'
      artifactName: 'dotnet-application'
      targetPath: '$(Agent.WorkFolder)/application'

  - script: |
      rm -rf $(Agent.WorkFolder)/ansible-files/*
    displayName: "Clean Target Folder on Agent"
  - task: CopyFiles@2
    displayName: "Copy files from Repos to Selfhosted Agent"
    inputs:
      SourceFolder: '$(System.DefaultWorkingDirectory)/Selfhosted-Ansible'
      Contents: '**/*'
      TargetFolder: '$(Agent.WorkFolder)/ansible-files'

  - script: |
      cd $(Agent.WorkFolder)/
      python3 -m venv myenv
      source myenv/bin/activate
      pip install -r $(Agent.WorkFolder)/ansible-files/requirements.txt

      cd $(Agent.WorkFolder)/ansible-files
      
      # Step 1: Download Terraform state file
      python3 fetch_state_file.py
      
      # Step 2: Parse IPs from state file
      python3 parse_ips_from_state.py

      # Step 3: Add Hosts to Known Hosts
      python3 add_to_known_hosts.py

      # Step 4: Run Ansible playbook with dynamic inventory
      ansible-playbook -i dynamic_inventory.json app-deploy-playbook.yaml -vvv
    displayName: "Run Ansible Playbook with Terraform State-Based Inventory"

```