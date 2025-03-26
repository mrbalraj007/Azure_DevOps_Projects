
# Create AD Service Account for AD Admin Migration
# Service Account Name: svc_ad_admin_migration
# Domain: singh.org.au
# Organizational Unit: SINGH-Integration

Import-Module ActiveDirectory

# Define account parameters
$accountName = "svc_ad_admin_migration"
$accountPassword = ConvertTo-SecureString "test@123456" -AsPlainText -Force
$domain = "singh.org.au"
$ouPath = "OU=SINGH-Integration,DC=singh,DC=org,DC=au"

# Create the service account
New-ADUser `
    -Name $accountName `
    -SamAccountName $accountName `
    -UserPrincipalName "$accountName@$domain" `
    -AccountPassword $accountPassword `
    -Enabled $true `
    -PasswordNeverExpires $true `
    -AccountResetPasswordOnNextLogon $false `
    -Path $ouPath `
    -ObjectClass user `
    -AccountType NormalAccount `
    -ServiceAccount

# Optional: Set additional properties if needed
 Set-ADUser -Identity $accountName -Description "Service account for AD admin migration"
