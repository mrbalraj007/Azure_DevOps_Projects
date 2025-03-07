# Instead of creating a new extension, we'll create a local file with instructions
resource "local_file" "videos_fix_instructions" {
  filename = "${path.module}/videos_fix_instructions.txt"
  content  = <<-EOT
    # Instructions to fix videos directory on VM02
    
    1. RDP to VM02 using the following credentials:
       - IP: ${azurerm_public_ip.rg01_public_ip2-eastus.ip_address}
       - Username: ${var.admin_username}
       - Password: (use the password from your terraform variables)
       
    2. Open PowerShell as Administrator on the VM
    
    3. Copy and paste the following script:
    
    ```powershell
    # Ensure IIS is installed
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools

    # Create the videos directory
    New-Item -Path 'C:\inetpub\wwwroot\videos' -ItemType Directory -Force

    # Create a test page
    Set-Content -Path 'C:\inetpub\wwwroot\videos\index.html' -Value '<html><body><h1>Videos directory is working!</h1><p>This is served from VM02</p></body></html>'

    # Create a web.config file
    Set-Content -Path 'C:\inetpub\wwwroot\videos\web.config' -Value '<?xml version="1.0" encoding="UTF-8"?><configuration><system.webServer><directoryBrowse enabled="true" /></system.webServer></configuration>'

    # Set proper permissions
    icacls 'C:\inetpub\wwwroot\videos' /reset
    icacls 'C:\inetpub\wwwroot\videos' /grant 'IIS_IUSRS:(OI)(CI)(RX)' /grant 'BUILTIN\IIS_IUSRS:(OI)(CI)(RX)'

    # Make sure videos is set up as an application in IIS
    Import-Module WebAdministration
    if(-not (Test-Path 'IIS:\Sites\Default Web Site\videos')) {
      New-WebApplication -Name 'videos' -Site 'Default Web Site' -PhysicalPath 'C:\inetpub\wwwroot\videos'
    }

    # Restart IIS
    iisreset /restart
    ```
    
    4. Verify that the videos directory is accessible by navigating to:
       - http://localhost/videos/
       - http://${azurerm_public_ip.rg01_public_ip2-eastus.ip_address}/videos/
  EOT
}

# Remove the duplicate output - it's already defined in output.tf
