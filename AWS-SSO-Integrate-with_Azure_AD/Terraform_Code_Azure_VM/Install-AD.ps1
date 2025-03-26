# Create a log file for installation tracking
Start-Transcript -Path "C:\AD_Installation_Log.txt" -Append

# Check if we're in the post-reboot phase
if (Test-Path "C:\AD_Install_Success.txt" -and -not (Test-Path "C:\AD_Users_Setup_Complete.txt")) {
    Write-Output "Post-reboot phase detected. Running user and group configuration..."
    
    # Function to check if AD is ready
    function Test-ADReady {
        try {
            # Check if AD Web Services is running
            $adws = Get-Service ADWS -ErrorAction SilentlyContinue
            if ($null -eq $adws) {
                Write-Output "ADWS service not found"
                return $false
            }
            if ($adws.Status -ne 'Running') {
                Write-Output "ADWS service status: $($adws.Status)"
                return $false
            }
            
            # Check if other essential services are running
            $requiredServices = @("NTDS", "Netlogon", "DNS")
            foreach ($svc in $requiredServices) {
                $service = Get-Service $svc -ErrorAction SilentlyContinue
                if ($null -eq $service -or $service.Status -ne 'Running') {
                    Write-Output "$svc service not running"
                    return $false
                }
            }
            
            # Try the AD cmdlets without importing module first (may already be loaded)
            try {
                Get-ADDomain -ErrorAction Stop | Out-Null
                return $true
            }
            catch [System.Management.Automation.CommandNotFoundException] {
                # Try to load AD module if command not found
                Import-Module ActiveDirectory -ErrorAction Stop
                Get-ADDomain -ErrorAction Stop | Out-Null
                return $true
            }
        }
        catch {
            Write-Output "AD not ready: $($_.Exception.Message)"
            return $false
        }
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
    
    try {
        # FIX 1: Ensure the correct script file is used and executed correctly
        $scriptPath = "C:\user_group.ps1"
        if (-not (Test-Path $scriptPath)) {
            Write-Output "Error: User group script not found at $scriptPath"
            
            # Improved fallback logic for locating the script
            $alternateLocations = @(
                "C:\Configure-AD-Users-and-Groups.ps1",
                "C:\Scripts\user_group.ps1"
            )
            foreach ($altPath in $alternateLocations) {
                if (Test-Path $altPath) {
                    Write-Output "Found script at alternate location: $altPath"
                    Copy-Item -Path $altPath -Destination $scriptPath -Force
                    Write-Output "Copied to standardized location: $scriptPath"
                    break
                }
            }
            
            # Check again
            if (-not (Test-Path $scriptPath)) {
                Write-Output "Critical error: Cannot find user/group script at any location"
                exit 1
            }
        }

        Write-Output "Executing user and group creation script..."
        & $scriptPath
        if ($LASTEXITCODE -ne 0) {
            Write-Output "User group script failed with exit code $LASTEXITCODE"
            exit 1
        }

        # Ensure marker file is created correctly
        New-Item -Path "C:\AD_Users_Setup_Complete.txt" -ItemType File -Value "Users and groups setup completed at $(Get-Date)" -Force
        Write-Output "User and group creation completed successfully!"
    }
    catch {
        Write-Output "Error during user and group creation: $_"
        exit 1
    }
    
    Stop-Transcript
    exit 0
}

# If we reach here, we're in the initial installation phase
try {
    Write-Output "Starting Active Directory installation..."

    # Install Active Directory
    Write-Output "Installing AD-Domain-Services feature..."
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

    # Promote the server to a domain controller
    $DomainName = "singh.org.au"
    Write-Output "Setting up domain: $DomainName"
    $SafeModeAdministratorPassword = ConvertTo-SecureString "SecureP@ssw0rd123!" -AsPlainText -Force

    Write-Output "Configuring AD Forest..."
    Install-ADDSForest -DomainName $DomainName `
                      -SafeModeAdministratorPassword $SafeModeAdministratorPassword `
                      -Force `
                      -NoRebootOnCompletion `
                      -ErrorAction Stop

    Write-Output "Active Directory installation completed successfully."
    
    # Ensure marker file is created correctly
    New-Item -Path "C:\AD_Install_Success.txt" -ItemType File -Value "Installation completed at $(Get-Date)" -Force
    
    # Schedule the user_group.ps1 script for post-reboot execution
    $batchContent = @"
@echo off
echo Starting user and group configuration at %date% %time% > C:\AD_User_Config_Log.txt
powershell.exe -ExecutionPolicy Bypass -File C:\user_group.ps1
echo Script completed with exit code %errorlevel% at %date% %time% >> C:\AD_User_Config_Log.txt
"@
    Set-Content -Path "C:\RunUserGroupConfig.cmd" -Value $batchContent -Force

    # Add the batch file to RunOnce registry key for post-reboot execution
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" -Name "RunUserGroupConfig" -Value "C:\RunUserGroupConfig.cmd" -PropertyType String -Force

    Write-Output "Server will restart to complete AD installation."
    
    # Give time for Windows to finish any pending operations
    Start-Sleep -Seconds 5
    
    # Initiate a restart to complete AD installation
    Restart-Computer -Force
}
catch {
    Write-Output "Error during AD installation: $_"
    $errorDetails = $_.Exception.ToString()
    New-Item -Path "C:\AD_Install_Error.txt" -ItemType File -Value "Installation error at $(Get-Date): $errorDetails" -Force
    exit 1
}
finally {
    Stop-Transcript
}
