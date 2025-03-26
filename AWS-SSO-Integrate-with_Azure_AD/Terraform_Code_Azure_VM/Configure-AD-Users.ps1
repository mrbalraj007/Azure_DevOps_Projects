# Script to wait for AD to be ready and then configure users and groups
Start-Transcript -Path "C:\AD_User_Config_Log.txt" -Append

function Test-ADReady {
    try {
        # Check if AD Web Services is running
        $adws = Get-Service ADWS -ErrorAction SilentlyContinue
        if ($adws.Status -ne 'Running') {
            return $false
        }
        
        # Try an AD cmdlet to verify AD is functional
        Get-ADDomain -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

Write-Output "Starting AD configuration check at $(Get-Date)"

# Check if AD installation has completed
if (-not (Test-Path "C:\AD_Install_Success.txt")) {
    Write-Output "AD installation marker file not found. AD may not be installed yet."
    exit 1
}

# Wait for AD to be ready (up to 15 minutes)
$maxWaitTime = [TimeSpan]::FromMinutes(15)
$startTime = Get-Date
$adReady = $false

Write-Output "Waiting for Active Directory services to be ready..."
while ((Get-Date) - $startTime -lt $maxWaitTime) {
    if (Test-ADReady) {
        $adReady = $true
        Write-Output "Active Directory is ready at $(Get-Date)"
        break
    }
    
    Write-Output "Active Directory services not ready yet. Waiting 30 seconds..."
    Start-Sleep -Seconds 30
}

if (-not $adReady) {
    Write-Output "Active Directory did not become ready within the allotted time. Exiting."
    exit 1
}

# AD is ready, execute the user and group creation script
Write-Output "Executing user and group creation script..."
try {
    $scriptPath = "C:\user_group.ps1"
    if (-not (Test-Path $scriptPath)) {
        Write-Output "Error: User group script not found at $scriptPath"
        exit 1
    }
    & $scriptPath
    if ($LASTEXITCODE -ne 0) {
        Write-Output "User and group creation script failed with exit code $LASTEXITCODE."
        exit 1
    }
    if (Test-Path "C:\AD_Users_Setup_Complete.txt") {
        Write-Output "User and group creation completed successfully."
    } else {
        Write-Output "User and group creation may not have completed successfully. Check the log files."
    }
}
catch {
    Write-Output "Error executing user and group creation script: $_"
    exit 1
}

Stop-Transcript
