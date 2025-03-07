# Script to create separate web applications in IIS

# Import necessary modules
Import-Module WebAdministration

# Create the videos application
$siteName = "Default Web Site"
$appName = "videos"
$appPath = "C:\inetpub\wwwroot\videos"

# Create the physical directory if it doesn't exist
if (-not (Test-Path $appPath)) {
    New-Item -ItemType Directory -Path $appPath -Force
}

# Create an index.html file
$htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Videos Application</title>
</head>
<body>
    <h1>This is the Videos application</h1>
    <p>Created as a separate web application in IIS</p>
</body>
</html>
"@
Set-Content -Path "$appPath\index.html" -Value $htmlContent

# Check if the application already exists
if (-not (Test-Path "IIS:\Sites\$siteName\$appName")) {
    # Create the application in IIS
    New-WebApplication -Name $appName -Site $siteName -PhysicalPath $appPath -ApplicationPool "DefaultAppPool"
    Write-Host "Web application '$appName' created successfully."
} else {
    Write-Host "Web application '$appName' already exists."
}

# Set permissions
$acl = Get-Acl $appPath
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS", "ReadAndExecute", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.SetAccessRule($rule)
Set-Acl $appPath $acl

# Restart IIS
iisreset /restart

Write-Host "Done. You should now be able to access the application at http://localhost/videos/"
