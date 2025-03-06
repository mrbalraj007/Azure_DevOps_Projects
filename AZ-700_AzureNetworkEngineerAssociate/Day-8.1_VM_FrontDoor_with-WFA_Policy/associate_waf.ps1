# Ensure we're logged in to Azure
$loginStatus = az account show 2>$null
if (-not $?) {
    Write-Host "Logging in to Azure..."
    az login
}

# Link the WAF policy to Front Door
Write-Host "Associating WAF policy with Front Door..."
az network front-door waf-policy frontend-endpoint link create `
  --resource-group az700-rg001 `
  --policy-name az700wafpolicy `
  --fd-name az700-frontdoor-demo-20250306 `
  --frontend-endpoint-name frontendEndpoint1
      
if ($?) {
    Write-Host "Successfully associated WAF policy with Front Door"
} else {
    Write-Host "Failed to associate WAF policy with Front Door"
    exit 1
}
