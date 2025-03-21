# PowerShell script to create OU, users and groups in Active Directory
# Domain: singh.org.au

# Importing the Active Directory module
Import-Module ActiveDirectory

# Define variables
$DomainDN = "DC=singh,DC=org,DC=au"
$OUName = "SINGH-Integration"
$OUDN = "OU=$OUName,$DomainDN"
$Password = ConvertTo-SecureString "P@ssw0rd123" -AsPlainText -Force
$Users = @("AWS-User-Admin", "AWS-User-CLI", "AWS-User-IAM", "AWS-User-Others")
$Groups = @("SINGH_Admin-Role", "SINGH_CLI-Role", "SINGH_IAM-Role", "SINGH_Others-Role")
$EnterpriseAdminsGroupDN = "CN=Enterprise Admins,CN=Users,$DomainDN"  # Correct DN for Enterprise Admins group

# Step 1: Create the Organizational Unit
if (Get-ADOrganizationalUnit -Filter "Name -eq '$OUName'" -SearchBase $DomainDN -ErrorAction SilentlyContinue) {
    Write-Host "OU $OUName already exists." -ForegroundColor Yellow
} else {
    try {
        Write-Host "Creating Organizational Unit: $OUName" -ForegroundColor Green
        New-ADOrganizationalUnit -Name $OUName -Path $DomainDN -ProtectedFromAccidentalDeletion $false
        Write-Host "OU created successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host ("Error creating OU: {0}" -f $_.Exception.Message) -ForegroundColor Red
        exit
    }
}

# Step 2: Create specified users
Write-Host "Creating users..." -ForegroundColor Green
foreach ($UserName in $Users) {
    if (Get-ADUser -Filter "SamAccountName -eq '$UserName'" -ErrorAction SilentlyContinue) {
        Write-Host "User $UserName already exists." -ForegroundColor Yellow
    } else {
        try {
            New-ADUser -Name $UserName `
                -SamAccountName $UserName `
                -UserPrincipalName "$UserName@singh.org.au" `
                -GivenName "AWS" `
                -Surname $UserName.Split("-")[2] `
                -DisplayName $UserName `
                -Path $OUDN `
                -AccountPassword $Password `
                -Enabled $true
            
            Write-Host "Created user: $UserName" -ForegroundColor Green
        }
        catch {
            Write-Host ("Error creating user {0}: {1}" -f $UserName, $_.Exception.Message) -ForegroundColor Red
        }
    }
}

# Step 3: Create specified groups as universal groups
Write-Host "Creating groups..." -ForegroundColor Green
foreach ($GroupName in $Groups) {
    if (Get-ADGroup -Filter "SamAccountName -eq '$GroupName'" -ErrorAction SilentlyContinue) {
        Write-Host "Group $GroupName already exists." -ForegroundColor Yellow
    } else {
        try {
            New-ADGroup -Name $GroupName `
                -SamAccountName $GroupName `
                -GroupCategory Security `
                -GroupScope Universal `
                -Path $OUDN  # Ensure groups are created inside the custom OU
            
            Write-Host "Created group: $GroupName" -ForegroundColor Green
        }
        catch {
            Write-Host ("Error creating group {0}: {1}" -f $GroupName, $_.Exception.Message) -ForegroundColor Red
        }
    }
}

# Step 4: Add each user to the corresponding group
Write-Host "Adding users to corresponding groups..." -ForegroundColor Green
for ($i = 0; $i -lt $Users.Length; $i++) {
    $UserName = $Users[$i]
    $GroupName = $Groups[$i]
    
    try {
        Add-ADGroupMember -Identity $GroupName -Members $UserName
        Write-Host "Added $UserName to $GroupName" -ForegroundColor Green
    }
    catch {
        Write-Host ("Error adding {0} to {1}: {2}" -f $UserName, $GroupName, $_.Exception.Message) -ForegroundColor Yellow
    }
}

# Step 5: Add each security group to the Enterprise Admins group
Write-Host "Adding security groups to Enterprise Admins group..." -ForegroundColor Green
foreach ($GroupName in $Groups) {
    try {
        Add-ADGroupMember -Identity $EnterpriseAdminsGroupDN -Members $GroupName
        Write-Host "Added $GroupName to Enterprise Admins group" -ForegroundColor Green
    }
    catch {
        Write-Host ("Error adding {0} to Enterprise Admins group: {1}" -f $GroupName, $_.Exception.Message) -ForegroundColor Yellow
    }
}

Write-Host "Script execution completed!" -ForegroundColor Cyan
Write-Host "Created 1 OU, 4 users, and 4 groups in the singh.org.au domain." -ForegroundColor Cyan
