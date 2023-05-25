# Set-VariablesFromKeyVault
This small script is able to load keyvault secrets to powershell variables

### Example:
```powershell
# install secret management module
Install-Module -Name Microsoft.PowerShell.SecretManagement
# install extension vault to store secrets to the local machine
Install-Module -Name Microsoft.PowerShell.SecretStore

# register a new local secret store
Register-SecretVault -Name mySecretStore -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault

# add two secrets to mySecretStore 
Set-Secret secret1 -Vault mySecretStore -Secret "this-is-the-value-for-secret1" -metadata @{"envname"="dev";"varname"="var1"} 
Set-Secret secret2 -Vault mySecretStore -Secret "this-is-the-value-for-secret2" -metadata @{"envname"="dev";"varname"="var2"}

# show the list of secrets stored into mySecretStore
PS > get-secretinfo -vault mySecretStore | fl

Name      : secret1
Type      : String
VaultName : mySecretStore
Metadata  : {[varname, var1], [envname, dev]}

Name      : secret2
Type      : String
VaultName : mySecretStore
Metadata  : {[varname, var2], [envname, dev]}

# import my functions for loading secrets
Import-Module .\ADMsecret.psm1

# create powershell variables with secret values based metadata envname and varname
Set-VariablesFromVault -vaultname mySecretStore -envname dev

# check the results
PS > get-variable

Name                     Value
----                     -----
dev_var1                 this-is-the-value-for-secret1
dev_var2                 this-is-the-value-for-secret2
......................................................
```