# Script to check Application Gateway backend health

# Parameters
param(
    [string]$AppGatewayName = "app-gateway",
    [string]$ResourceGroupName = "az700-rg001"
)

# Login to Azure (uncomment if running manually)
# Connect-AzAccount

# Get the Application Gateway
Write-Host "Getting Application Gateway $AppGatewayName..."
$appGw = Get-AzApplicationGateway -Name $AppGatewayName -ResourceGroupName $ResourceGroupName

if (!$appGw) {
    Write-Error "Application Gateway not found"
    exit 1
}

# Check backend health
Write-Host "Checking backend health..."
$backendHealth = Get-AzApplicationGatewayBackendHealth -ApplicationGateway $appGw

# Display the results
Write-Host "Application Gateway backend health status:" -ForegroundColor Green
foreach ($backendPool in $backendHealth.BackendAddressPools) {
    Write-Host "Backend pool: $($backendPool.Name)" -ForegroundColor Yellow
    
    foreach ($server in $backendPool.BackendHttpSettingsCollection) {
        Write-Host "  HTTP Settings: $($server.BackendHttpSettings.Name)" -ForegroundColor Yellow
        
        foreach ($serverHealth in $server.Servers) {
            $healthStatus = $serverHealth.Health
            $color = switch ($healthStatus) {
                "Healthy" { "Green" }
                "Unhealthy" { "Red" }
                default { "Yellow" }
            }
            
            Write-Host "    Server: $($serverHealth.Address) - Status: $healthStatus" -ForegroundColor $color
            if ($serverHealth.Health -ne "Healthy") {
                Write-Host "      Details: $($serverHealth.Description)" -ForegroundColor Red
            }
        }
    }
}

# Check Application Gateway public IP
$publicIp = Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName | Where-Object { $_.Name -eq $appGw.FrontendIpConfiguration[0].PublicIpAddress.Id.Split('/')[-1] }
Write-Host "Application Gateway Public IP: $($publicIp.IpAddress)" -ForegroundColor Cyan

# Test connectivity to backend servers
Write-Host "Testing connectivity to backend servers..." -ForegroundColor Cyan
$backendPools = $appGw.BackendAddressPools
foreach ($pool in $backendPools) {
    foreach ($address in $pool.BackendAddresses) {
        if ($address.IpAddress) {
            $ipAddress = $address.IpAddress
            $testResult = Test-NetConnection -ComputerName $ipAddress -Port 80
            
            if ($testResult.TcpTestSucceeded) {
                Write-Host "  Connection to $ipAddress:80 - Success" -ForegroundColor Green
            } else {
                Write-Host "  Connection to $ipAddress:80 - Failed" -ForegroundColor Red
            }
        }
    }
}

Write-Host "Path testing from your machine:" -ForegroundColor Cyan
Write-Host "  Try accessing: http://$($publicIp.IpAddress)/videos/" -ForegroundColor Cyan
Write-Host "  Try accessing: http://$($publicIp.IpAddress)/images/" -ForegroundColor Cyan
