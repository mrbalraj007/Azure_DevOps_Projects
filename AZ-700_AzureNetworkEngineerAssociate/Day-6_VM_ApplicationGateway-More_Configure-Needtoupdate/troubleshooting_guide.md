# Application Gateway Troubleshooting Guide

## Current Status

- ✅ **Direct VM access**: http://52.191.28.128/videos/ - WORKING
- ❌ **App Gateway access**: http://13.92.199.248/videos/ - NOT WORKING (404 error)
- ✅ **App Gateway images**: http://13.92.199.248/images/ - WORKING

## Step-by-Step Troubleshooting

### 1. Verify Backend VM Configuration

1. **Connect via RDP to VM02**:
   - IP: 52.191.28.128
   - Username: adminuser
   - Password: (your password)

2. **Verify IIS configuration**:
   ```powershell
   # Check IIS status
   Get-Service -Name W3SVC
   
   # Check if videos directory exists
   Test-Path 'C:\inetpub\wwwroot\videos'
   
   # Check content
   Get-ChildItem 'C:\inetpub\wwwroot\videos'
   ```

3. **Verify IIS Application**:
   - Open IIS Manager
   - Expand "Default Web Site"
   - Check if "videos" appears as an application
   - If not, right-click -> Convert to Application

4. **Test access from VM**:
   ```powershell
   Invoke-WebRequest -Uri http://localhost/videos/ -UseBasicParsing
   ```

### 2. Check Application Gateway Health

1. **Check backend health**:
   - Portal: App Gateway > Backend Health
   - Look for any unhealthy status in the "video" backend pool

2. **Check health probe settings**:
   - Portal: App Gateway > Health probes
   - Verify videos-health-probe configuration

3. **Modify health probe** (if needed):
   ```powershell
   # Connect to Azure
   Connect-AzAccount
   
   # Get app gateway
   $appgw = Get-AzApplicationGateway -Name "app-gateway" -ResourceGroupName "az700-rg001"
   
   # Modify probe
   $probe = Get-AzApplicationGatewayProbeConfig -ApplicationGateway $appgw -Name "videos-health-probe"
   Set-AzApplicationGatewayProbeConfig -ApplicationGateway $appgw -Name "videos-health-probe" -Protocol Http -Path "/videos/" -Interval 30 -Timeout 30 -UnhealthyThreshold 3 -PickHostNameFromBackendHttpSettings -MinServers 0
   
   # Update app gateway
   Set-AzApplicationGateway -ApplicationGateway $appgw
   ```

### 3. Investigate Path-Based Routing

1. **View URL path map**:
   - Portal: App Gateway > Rules > Rule attachments > path-based-routing
   - Verify paths: `/videos/*` and `/videos`
   - Verify backend pool: "video"

2. **Try alternative paths**:
   - http://13.92.199.248/videos
   - http://13.92.199.248/videos/index.html

### 4. Check Network Connectivity

1. **Test connectivity from App Gateway subnet to VM**:
   - Verify NSG rules on both subnets
   - Check UDR (User Defined Routes)
   - Ensure VM firewall allows incoming traffic

2. **Network Watcher packet capture** (optional):
   - Start packet capture on VM NIC
   - Try accessing the videos path
   - Check if requests reach the VM

### 5. Workarounds

If all troubleshooting fails, here are the workarounds:

1. **Use direct VM access**:
   - Access videos directly: http://52.191.28.128/videos/
   - Use the videos_access.html page for redirection

2. **Request URL with hostname**:
   - Add to hosts file: `13.92.199.248 videos-direct.example.com`
   - Access: http://videos-direct.example.com/videos/

3. **Simple Proxy Page**:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Videos Proxy</title>
    <script>
        window.onload = function() {
            fetch('http://52.191.28.128/videos/')
                .then(response => response.text())
                .then(data => {
                    document.getElementById('content').innerHTML = data;
                });
        }
    </script>
</head>
<body>
    <h1>Videos Content (via proxy):</h1>
    <div id="content">Loading...</div>
</body>
</html>
```

4. **Consider recreating the App Gateway** if all else fails.

## Common Issues & Solutions

1. **404 Not Found**:
   - Check if path exists on backend server
   - Verify URL path map configuration
   - Check backend pool health

2. **Backend health fails**:
   - Check if backend VM is running
   - Verify health probe path exists
   - Check NSG and firewall settings

3. **Routing rule conflicts**:
   - Ensure unique listeners for each rule
   - Check priority values (lower number = higher priority)

## Azure Support

If nothing works, consider opening a support case with Microsoft:
https://azure.microsoft.com/support/create-ticket/
