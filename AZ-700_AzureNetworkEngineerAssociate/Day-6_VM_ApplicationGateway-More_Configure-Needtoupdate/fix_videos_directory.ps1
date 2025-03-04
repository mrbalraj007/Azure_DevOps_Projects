# This script will comprehensively fix the videos directory issue

# 1. Ensure IIS is installed
Import-Module ServerManager
if ((Get-WindowsFeature -Name Web-Server).InstallState -ne "Installed") {
    Write-Host "Installing IIS..."
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools
}

# 2. Create videos directory with proper permissions
Write-Host "Creating videos directory and setting permissions..."
$videosDir = "C:\inetpub\wwwroot\videos"
if (-not (Test-Path $videosDir)) {
    New-Item -Path $videosDir -ItemType Directory -Force
}

# Create test HTML file
$htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Videos Directory</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #0066cc; }
    </style>
</head>
<body>
    <h1>This is the VIDEOS server (VM02)</h1>
    <p>If you can see this page, the videos directory is working correctly!</p>
    <p>Current time: $(Get-Date)</p>
</body>
</html>
"@

Set-Content -Path "$videosDir\index.html" -Value $htmlContent

# 3. Set proper IIS permissions
icacls $videosDir /reset
icacls $videosDir /grant "IIS_IUSRS:(OI)(CI)(RX)" /grant "BUILTIN\IIS_IUSRS:(OI)(CI)(RX)" /grant "BUILTIN\Users:(OI)(CI)(RX)" /grant "NT SERVICE\TrustedInstaller:(OI)(CI)(F)"

# 4. Create a web.config file to ensure directory browsing is enabled
$webConfigContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <system.webServer>
        <directoryBrowse enabled="true" />
    </system.webServer>
</configuration>
"@

Set-Content -Path "$videosDir\web.config" -Value $webConfigContent

# 5. Create additional test files
Set-Content -Path "$videosDir\test.html" -Value "<html><body><h1>Test Page</h1><p>This is a test page in the videos directory.</p></body></html>"

# 6. Restart IIS
Write-Host "Restarting IIS..."
iisreset /restart

Write-Host "Done! The videos directory should now be accessible."
Write-Host "Try accessing: http://localhost/videos/"
