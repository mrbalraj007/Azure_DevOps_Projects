
### <span style="color: Yellow;">**Step-07: Create Service Principle Account**</span>
- Will create a [service principle account](https://www.youtube.com/watch?v=CUHtHGS4xEc&list=PLJcpyd04zn7rxl0X8mBdysb5NjUGIsJ7W&index=3).
- Take putty session of Agent VM and do the following
```sh
az login --use-device-code
```
![image-84](https://github.com/user-attachments/assets/f1f4e869-4076-44b3-9c3b-81043d80b2b5)

- To create a SP account
```sh
az ad sp <name_of_SP> --role="contributor" --scope="subscriptions/SUBSCRIPTION_ID"
```
![image-85](https://github.com/user-attachments/assets/24c5abbf-2501-4e5a-b45e-e51aca6707a4)

### <span style="color: Yellow;">**Step-08: Configure the Service Connection for "```Azure Resource Manager```"**</span>
   - Steps to configure connection for [Azure Resource Manager](https://learn.microsoft.com/en-us/azure/devops/pipelines/release/configure-workload-identity?view=azure-devops&tabs=managed-identity):

![image-17](https://github.com/user-attachments/assets/8e77bdc8-4c48-42c8-8ceb-92d7a0ab0dc8)
![image-86](https://github.com/user-attachments/assets/d274d09b-1b45-4168-842c-f548386090de)
![image-87](https://github.com/user-attachments/assets/9e1cc145-5490-4298-b4fb-dd7b0e633e30)

### <span style="color: Yellow;">**Step-09: Configure the Service Connection for"```SonarQube```, ```Docker registory``` and ```AKS Cluster``` **</span>

  - Select the project and project setting:
    - Steps to configure connection for SonarQube:
![image-9](https://github.com/user-attachments/assets/8d10a5f5-f608-47e8-bae0-308efd0148ab)
![image-10](https://github.com/user-attachments/assets/405d3300-0c8b-49f5-ad2a-6a45a9fdda4b)

    - Steps to configure connection for Dockerregistory:
![image-11](https://github.com/user-attachments/assets/b8dd8c30-1740-4df7-97bc-2d2aec9d5252)
![image-12](https://github.com/user-attachments/assets/f3fa571e-cb34-4580-8f74-327c41e7941c)

    - Steps to configure connection for Kubernetes:
![image-13](https://github.com/user-attachments/assets/bdbaf9e1-1bb6-4ef1-8ef8-ca35cca94ca3) 
    - A popup will appear asking for login credentials. Use the same credentials you used for the UI portal login.
