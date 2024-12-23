### To set environment variables permanently in Windows, you need to add them to the system or user environment variables. Here's how you can do it:

- Option 1: Using PowerShell

```sh
You can use the SetEnvironmentVariable method to set environment variables permanently for the current user or the system.

For Current User:
This sets the variables for the currently logged-in user only:
```
```powershell
[System.Environment]::SetEnvironmentVariable("ARM_CLIENT_ID", "xxxxxxxxxxxxxxxxxxxxxx", "User")
[System.Environment]::SetEnvironmentVariable("ARM_CLIENT_SECRET", "xxxxxxxxxxxxxxxxxxxxxx", "User")
[System.Environment]::SetEnvironmentVariable("ARM_TENANT_ID", "xxxxxxxxxxxxxxxxxxxxxx", "User")
[System.Environment]::SetEnvironmentVariable("ARM_SUBSCRIPTION_ID", "xxxxxxxxxxxxxxxxxxxxxx", "User")
```

- For System (All Users):
This sets the variables for all users on the system (requires administrator privileges):

```powershell
[System.Environment]::SetEnvironmentVariable("ARM_CLIENT_ID", "xxxxxxxxxxxxxxxxxxxxxx", "Machine")
[System.Environment]::SetEnvironmentVariable("ARM_CLIENT_SECRET", "xxxxxxxxxxxxxxxxxxxxxx", "Machine")
[System.Environment]::SetEnvironmentVariable("ARM_TENANT_ID", "xxxxxxxxxxxxxxxxxxxxxx", "Machine")
[System.Environment]::SetEnvironmentVariable("ARM_SUBSCRIPTION_ID", "xxxxxxxxxxxxxxxxxxxxxx", "Machine")
```
After running these commands, the variables will persist across sessions.

- Option 2: Using the GUI

Open System Properties:

Press Win + R, type SystemPropertiesAdvanced, and press Enter.
Access Environment Variables:

Click on the "Environment Variables" button.
Add Variables:

Under "User variables" (for the current user) or "System variables" (for all users), click "New."
Add each variable name (ARM_CLIENT_ID, etc.) and its value.
Save:

Click OK to save and close the dialogs.


- Option 3: Using Command Prompt
You can use the setx command to set environment variables permanently.

For Current User:
```cmd
setx ARM_CLIENT_ID "xxxxxxxxxxxxxxxxxxxxxx"
setx ARM_CLIENT_SECRET "xxxxxxxxxxxxxxxxxxxxxx"
setx ARM_TENANT_ID "xxxxxxxxxxxxxxxxxxxxxx"
setx ARM_SUBSCRIPTION_ID "xxxxxxxxxxxxxxxxxxxxxx"
```
- For System (requires admin privileges):
```cmd
setx ARM_CLIENT_ID "xxxxxxxxxxxxxxxxxxxxxx" /M
setx ARM_CLIENT_SECRET "xxxxxxxxxxxxxxxxxxxxxx" /M
setx ARM_TENANT_ID "xxxxxxxxxxxxxxxxxxxxxx" /M
setx ARM_SUBSCRIPTION_ID "xxxxxxxxxxxxxxxxxxxxxx" /M
```
- Verify the Environment Variables
- To verify that the variables are set:

Open a new Command Prompt or PowerShell session.
Run ```echo %ARM_CLIENT_ID%``` or ```echo $Env:ARM_CLIENT_ID``` (in PowerShell) to confirm the values.

These methods ensure the variables persist across system reboots and terminal sessions.

### To remove permanently set environment variables in Windows, you can use PowerShell, the GUI, or Command Prompt. Below are the methods:

Option 1: Using PowerShell
You can remove permanent environment variables using the SetEnvironmentVariable method by setting their value to null.

For Current User:
powershell
Copy code
[System.Environment]::SetEnvironmentVariable("ARM_CLIENT_ID", $null, "User")
[System.Environment]::SetEnvironmentVariable("ARM_CLIENT_SECRET", $null, "User")
[System.Environment]::SetEnvironmentVariable("ARM_TENANT_ID", $null, "User")
[System.Environment]::SetEnvironmentVariable("ARM_SUBSCRIPTION_ID", $null, "User")
For System (All Users):
Requires administrator privileges:

powershell
Copy code
[System.Environment]::SetEnvironmentVariable("ARM_CLIENT_ID", $null, "Machine")
[System.Environment]::SetEnvironmentVariable("ARM_CLIENT_SECRET", $null, "Machine")
[System.Environment]::SetEnvironmentVariable("ARM_TENANT_ID", $null, "Machine")
[System.Environment]::SetEnvironmentVariable("ARM_SUBSCRIPTION_ID", $null, "Machine")
Option 2: Using the GUI
Open System Properties:

Press Win + R, type SystemPropertiesAdvanced, and press Enter.
Access Environment Variables:

Click on the "Environment Variables" button.
Remove Variables:

Under "User variables" or "System variables," locate the variables (ARM_CLIENT_ID, etc.).
Select each variable and click "Delete."
Save Changes:

Click OK to save and close the dialogs.
Option 3: Using Command Prompt
The setx command cannot directly delete environment variables, but you can overwrite them with an empty value or delete them in the registry manually.

For Current User:
Overwrite the variables with an empty value (effectively removing them):

cmd
Copy code
setx ARM_CLIENT_ID "" 
setx ARM_CLIENT_SECRET "" 
setx ARM_TENANT_ID "" 
setx ARM_SUBSCRIPTION_ID "" 
For System (requires admin privileges):
cmd
Copy code
setx ARM_CLIENT_ID "" /M
setx ARM_CLIENT_SECRET "" /M
setx ARM_TENANT_ID "" /M
setx ARM_SUBSCRIPTION_ID "" /M
Option 4: Manually Remove from the Registry
Open Registry Editor:

Press Win + R, type regedit, and press Enter.
Navigate to the Keys:

For User variables: HKEY_CURRENT_USER\Environment
For System variables: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
Delete the Variables:

Locate the variables (ARM_CLIENT_ID, etc.), right-click on them, and select "Delete."
Restart the System:

Restart to apply changes.
Verify the Variables Are Removed
Open a new PowerShell or Command Prompt session.
Run echo $Env:ARM_CLIENT_ID (PowerShell) or echo %ARM_CLIENT_ID% (Command Prompt). If the variable has been removed, no value will be displayed.