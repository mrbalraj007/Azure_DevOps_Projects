*****************
- Steps to Create a Service Connection Using Azure CLI:
Prerequisites:
Ensure you have the Azure CLI installed and authenticated with your Azure DevOps organization:
```bash
az login
az devops login --organization https://dev.azure.com/<your_organization>
```
Set the default DevOps organization and project:
```bash
az devops configure --defaults organization=https://dev.azure.com/<your_organization> project=<your_project>
```
- Example Command to Create a Service Connection:
  - Create an Azure Resource Manager (ARM) Service Connection:
    - Generate a configuration JSON for the service endpoint: Save this as `service-endpoint-config.json`:
```bash
{
    "name": "MyAzureServiceConnection",
    "type": "azurerm",
    "authorization": {
        "parameters": {
            "servicePrincipalId": "appId Value",
            "servicePrincipalKey": "appId password",
            "tenantId": "appId tenantId"
        },
        "scheme": "ServicePrincipal"
    },
    "data": {
        "subscriptionId": "subscription ID",
        "subscriptionName": "subscription-name",
        "environment": "AzureCloud"
    }
}

```
Run the command with the configuration file:

```bash
az devops service-endpoint create \
  --service-endpoint-configuration service-endpoint-config.json
```
- Verify the Service Connection:
After the command executes successfully, verify the service connection in your Azure DevOps portal under Project Settings > Service Connections.
