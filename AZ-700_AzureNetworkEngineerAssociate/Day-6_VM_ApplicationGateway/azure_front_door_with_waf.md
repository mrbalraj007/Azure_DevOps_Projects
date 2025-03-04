
# Azure Front Door with WAF

## Introduction
This document provides a summary of the YouTube video titled "Azure Front Door With WAF In Hindi". The video explains the Azure Front Door service, its features, and how to configure it with Web Application Firewall (WAF).

## Key Topics Covered

### 1. Overview of Azure Front Door
- **Definition**: Azure Front Door is a global, scalable entry point that uses Microsoft's global network to improve the performance and security of web applications.
- **Purpose**: It provides load balancing, SSL offloading, and web application firewall capabilities.

### 2. Comparison with Other Services
- **Traffic Manager**: Both are global services, but Front Door provides additional features like WAF and content-based routing.
- **Application Gateway**: Front Door offers global load balancing, whereas Application Gateway is more suited for regional load balancing.

### 3. Features of Azure Front Door
- **Global Load Balancing**: Distributes traffic across multiple regions.
- **Web Application Firewall (WAF)**: Protects web applications from common threats.
- **Microsoft Global Network**: Utilizes Microsoft's extensive global network for low latency and high availability.
- **TCP Split and Anycast Protocol**: Enhances performance by splitting TCP connections and using the nearest point of presence (PoP).

### 4. Configuring Azure Front Door
- **Steps**:
  1. Navigate to the Azure portal and create a new Front Door.
  2. Configure the Front Door settings, including the frontend host, backend pools, and routing rules.
  3. Add backend pools with the necessary endpoints and health probes.
  4. Define routing rules to manage traffic based on URL paths and other criteria.

### 5. Implementing Web Application Firewall (WAF)
- **Purpose**: WAF protects web applications from threats like SQL injection and cross-site scripting.
- **Configuration**:
  1. Create a WAF policy in the Azure portal.
  2. Attach the WAF policy to the Front Door.
  3. Configure custom rules and conditions based on IP addresses, geolocation, and request size.

### 6. Practical Demonstration
- **Example**: The video demonstrates configuring a Front Door with two backend web servers located in different regions (Central India and East US).
- **Steps**:
  1. Create a Front Door and add backend pools with the web servers.
  2. Configure routing rules to direct traffic based on URL paths.
  3. Implement a WAF policy to protect the application.

## Key Topics Covered

### 1. Azure Virtual Network (VNet) Peering
- **Definition**: VNet peering connects two Azure virtual networks, enabling resources in each VNet to communicate with each other.
- **Types**: 
  - **Intra-region VNet Peering**: Peering within the same Azure region.
  - **Global VNet Peering**: Peering across different Azure regions.
- **Benefits**: Low latency, high bandwidth, and cost-effective.

### 2. Configuring VNet Peering
- **Steps**:
  1. Navigate to the Azure portal.
  2. Select the virtual network to peer.
  3. Choose "Peerings" and add a new peering.
  4. Configure the peering settings, including the remote virtual network and permissions.
  5. Validate and create the peering.

### 3. Network Security Groups (NSGs)
- **Purpose**: NSGs are used to filter network traffic to and from Azure resources.
- **Components**:
  - **Inbound Security Rules**: Define the allowed inbound traffic.
  - **Outbound Security Rules**: Define the allowed outbound traffic.
- **Configuration**:
  - Create an NSG.
  - Associate the NSG with subnets or network interfaces.
  - Define security rules based on priority, source, destination, and port.

### 4. Azure Firewall
- **Overview**: A managed, cloud-based network security service that protects Azure Virtual Network resources.
- **Features**:
  - **High Availability**: Built-in high availability.
  - **Scalability**: Automatically scales with network traffic.
  - **Threat Intelligence**: Integration with Microsoft Threat Intelligence.
- **Deployment**:
  - Create an Azure Firewall.
  - Configure firewall rules for application and network traffic.
  - Associate the firewall with VNets.

## Conclusion
The video provides a detailed guide on configuring Azure Front Door with WAF, highlighting its features and benefits. Azure Front Door is a powerful service for improving the performance and security of web applications, especially those with global reach.

- Firewall needs to stop on all VMs
```sh
netsh advfirewall show all state
netsh advfirewall set allprofiles state off
```
[YouTube Link](https://www.youtube.com/watch?v=8iutz97ANP8&list=PLAwzouYxcpPjTtRB1FNQ5iLGkSaYD9JFb&index=8)

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb
https://github.com/Azure/terraform-azurerm-loadbalancer

https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-nat-pool-migration?tabs=azure-cli