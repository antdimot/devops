# Powershell Scripts

## Set-VariablesFromKeyVault
This small script is able to load keyvault secrets to powershell variables

### Example:
```powershell
# installation of secret management modules
Install-Module -Name Microsoft.PowerShell.SecretManagement
Install-Module -Name Microsoft.PowerShell.SecretStore

# register a new local secret store
Register-SecretVault -Name mySecretStore -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault

# add two examples of secrets to mySecretStore 
Set-Secret secret1 -Vault mySecretStore -Secret "this-is-the-value-for-secret1" -metadata @{"envname"="dev";"varname"="var1"} 
Set-Secret secret2 -Vault mySecretStore -Secret "this-is-the-value-for-secret2" -metadata @{"envname"="dev";"varname"="var2"}

# get secrets list stored into mySecretStore
PS > get-secretinfo -vault mySecretStore | fl

Name      : dev_var1
Type      : String
VaultName : mySecretStore
Metadata  : {[varname, appid], [envname, dev]}

Name      : dev_var2
Type      : String
VaultName : mySecretStore
Metadata  : {[varname, secret], [envname, dev]}

# import module
Import-Module .\ADMsecret.psm1

# set powershell variables with secret values with metadata envname equals to dev
Set-VariablesFromKeyVault -vaultname mySecretStore -envname dev

# check if variables are created
PS > get-variable

Name                     Value
----                     -----
dev_var1                 this-is-the-value-for-secret1
dev_var2                 this-is-the-value-for-secret2
......................................................
```