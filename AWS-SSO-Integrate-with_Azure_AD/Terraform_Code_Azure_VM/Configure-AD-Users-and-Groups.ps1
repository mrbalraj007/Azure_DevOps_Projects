
param (
    [string]$DomainName = "singh.org.au",
    [string]$OUName = "SINGH-Integration",
    [string[]]$Users = @("AWS-User-Admin", "AWS-User-CLI", "AWS-User-IAM", "AWS-User-Others"),
    [string[]]$Groups = @("SINGH_Admin-Role", "SINGH_CLI-Role", "SINGH_IAM-Role", "SINGH_Others-Role")
)

# Start logging
Start-Transcript -Path "C:\AD_Users_Creation_Log.txt" -Append

try {
    # Import Active Directory module
    Write-Host "Importing Active Directory module..." -ForegroundColor Green
    Import-Module ActiveDirectory -ErrorAction Stop

    # Wait for AD to be ready
    Write-Host "Waiting for Active Directory services to be ready..." -ForegroundColor Cyan
    $maxWaitTime = [TimeSpan]::FromMinutes(15)
    $startTime = Get-Date
    $adReady = $false

    while ((Get-Date) - $startTime -lt $maxWaitTime) {
        try {
            # Check if AD Web Services is running
            $adws = Get-Service ADWS -ErrorAction SilentlyContinue
            if ($adws.Status -ne 'Running') {
                throw "ADWS service is not running."
            }

            # Verify AD functionality
            Get-ADDomain -ErrorAction Stop | Out-Null
            $adReady = $true
            Write-Host "Active Directory is ready at $(Get-Date)" -ForegroundColor Green
            break
        }
        catch {
            Write-Host "Active Directory services not ready yet. Waiting 30 seconds..." -ForegroundColor Yellow
            Start-Sleep -Seconds 30
        }
    }

    if (-not $adReady) {
        Write-Host "Active Directory did not become ready within the allotted time. Exiting." -ForegroundColor Red
        exit 1
    }

    # Define variables
    $DomainDN = ($DomainName -replace "\.", ",DC=") -replace "^", "DC="
    $OUDN = "OU=$OUName,$DomainDN"
    $Password = ConvertTo-SecureString "P@ssw0rd123" -AsPlainText -Force
    $EnterpriseAdminsGroupDN = "CN=Enterprise Admins,CN=Users,$DomainDN"

    # Step 1: Create the Organizational Unit
    Write-Host "Checking for OU: $OUName" -ForegroundColor Cyan
    try {
        if (Get-ADOrganizationalUnit -Filter {Name -eq $OUName} -SearchBase $DomainDN -ErrorAction SilentlyContinue) {
            Write-Host "OU $OUName already exists." -ForegroundColor Yellow
        } else {
            Write-Host "Creating Organizational Unit: $OUName" -ForegroundColor Green
            New-ADOrganizationalUnit -Name $OUName -Path $DomainDN -ProtectedFromAccidentalDeletion $false
            Write-Host "OU created successfully!" -ForegroundColor Green
        }
    }
    catch {
        Write-Host ("Error creating OU: {0}" -f $_.Exception.Message) -ForegroundColor Red
        throw $_
    }

    # Step 2: Create specified users
    Write-Host "Creating users..." -ForegroundColor Green
    foreach ($UserName in $Users) {
        try {
            if (Get-ADUser -Filter {SamAccountName -eq $UserName} -ErrorAction SilentlyContinue) {
                Write-Host "User $UserName already exists." -ForegroundColor Yellow
            } else {
                New-ADUser -Name $UserName `
                    -SamAccountName $UserName `
                    -UserPrincipalName "$UserName@$DomainName" `
                    -GivenName "AWS" `
                    -Surname ($UserName.Split("-")[-1]) `
                    -DisplayName $UserName `
                    -Path $OUDN `
                    -AccountPassword $Password `
                    -Enabled $true
                
                Set-ADUser -Identity $UserName -Description "User: $UserName"
                Write-Host "Created user: $UserName" -ForegroundColor Green
            }
        }
        catch {
            Write-Host ("Error creating user {0}: {1}" -f $UserName, $_.Exception.Message) -ForegroundColor Red
        }
    }

    # Step 3: Create specified groups
    Write-Host "Creating groups..." -ForegroundColor Green
    foreach ($GroupName in $Groups) {
        try {
            if (Get-ADGroup -Filter {SamAccountName -eq $GroupName} -ErrorAction SilentlyContinue) {
                Write-Host "Group $GroupName already exists." -ForegroundColor Yellow
            } else {
                New-ADGroup -Name $GroupName `
                    -SamAccountName $GroupName `
                    -GroupCategory Security `
                    -GroupScope Universal `
                    -Path $OUDN
                
                Set-ADGroup -Identity $GroupName -Description "Group: $GroupName"
                Write-Host "Created group: $GroupName" -ForegroundColor Green
            }
        }
        catch {
            Write-Host ("Error creating group {0}: {1}" -f $GroupName, $_.Exception.Message) -ForegroundColor Red
        }
    }

    # Step 4: Add users to groups
    Write-Host "Adding users to groups..." -ForegroundColor Green
    for ($i = 0; $i -lt $Users.Length -and $i -lt $Groups.Length; $i++) {
        $UserName = $Users[$i]
        $GroupName = $Groups[$i]
        try {
            Add-ADGroupMember -Identity $GroupName -Members $UserName -ErrorAction Stop
            Write-Host "Added $UserName to $GroupName" -ForegroundColor Green
        }
        catch {
            Write-Host ("Error adding {0} to {1}: {2}" -f $UserName, $GroupName, $_.Exception.Message) -ForegroundColor Red
        }
    }

    # Step 5: Add groups to Enterprise Admins
    Write-Host "Adding groups to Enterprise Admins group..." -ForegroundColor Green
    try {
        foreach ($GroupName in $Groups) {
            Add-ADGroupMember -Identity $EnterpriseAdminsGroupDN -Members $GroupName -ErrorAction Stop
            Write-Host "Added $GroupName to Enterprise Admins group" -ForegroundColor Green
        }
    }
    catch {
        Write-Host ("Error adding groups to Enterprise Admins group: {0}" -f $_.Exception.Message) -ForegroundColor Yellow
    }

    # Step 6: Create the service account
    Write-Host "Creating service account: svc_admin_migration..." -ForegroundColor Green
    try {
        $ServiceAccountName = "svc_admin_migration"
        $ServiceAccountPassword = ConvertTo-SecureString "test@123456" -AsPlainText -Force

        if (Get-ADUser -Filter {SamAccountName -eq $ServiceAccountName} -ErrorAction SilentlyContinue) {
            Write-Host "Service account $ServiceAccountName already exists." -ForegroundColor Yellow
        } else {
            # Fixed line - removed comment and ensured proper line continuation
            New-ADUser -Name "svc_admin_migration" `
                -SamAccountName $ServiceAccountName `
                -UserPrincipalName "$ServiceAccountName@$DomainName" `
                -GivenName "Service" `
                -Surname "Account" `
                -DisplayName "Service Account for AD Admin Migration" `
                -Path $OUDN `
                -AccountPassword $ServiceAccountPassword `
                -Enabled $true

            Set-ADUser -Identity $ServiceAccountName -Description "Service Account for AD Admin Migration"
            Write-Host "Created service account: $ServiceAccountName" -ForegroundColor Green
        }
    }
    catch {
        Write-Host ("Error creating service account {0}: {1}" -f $ServiceAccountName, $_.Exception.Message) -ForegroundColor Red
    }

    Write-Host "User and group setup completed successfully!" -ForegroundColor Cyan
    New-Item -Path "C:\AD_Users_Setup_Complete.txt" -ItemType File -Value "Users and groups setup completed at $(Get-Date)" -Force
    exit 0
}
catch {
    Write-Host "Critical error: $_" -ForegroundColor Red
    New-Item -Path "C:\AD_User_Error.txt" -ItemType File -Value "Error in Configure-AD-Users-and-Groups.ps1 at $(Get-Date): $($_.Exception.Message)" -Force
    exit 1
}
finally {
    Stop-Transcript
}
