# Run this script on VM02 to diagnose the issue with the /videos/ path

# Check if IIS is installed and running
Write-Host "Checking IIS status..."
$iisStatus = Get-Service -Name W3SVC
Write-Host "IIS Status: $($iisStatus.Status)"

# Check if the videos directory exists
Write-Host "Checking if videos directory exists..."
if (Test-Path 'C:\inetpub\wwwroot\videos') {
    Write-Host "Directory exists!"
    # Check contents
    Get-ChildItem 'C:\inetpub\wwwroot\videos' | ForEach-Object { Write-Host $_.Name }
} else {
    Write-Host "Directory does not exist!"
    # Create it
    Write-Host "Creating directory..."
    New-Item -Path 'C:\inetpub\wwwroot\videos' -ItemType Directory -Force
    Set-Content -Path 'C:\inetpub\wwwroot\videos\index.html' -Value '<html><body><h1>This is the VIDEOS server (VM02)</h1></body></html>'
}

# Check permissions
Write-Host "Checking permissions..."
icacls 'C:\inetpub\wwwroot\videos'

# Set correct permissions
Write-Host "Setting correct permissions..."
icacls 'C:\inetpub\wwwroot\videos' /grant 'IIS_IUSRS:(OI)(CI)(RX)' /grant 'BUILTIN\Users:(OI)(CI)(RX)'

# Restart IIS
Write-Host "Restarting IIS..."
iisreset /restart

Write-Host "Done! Try accessing /videos/ path now."
