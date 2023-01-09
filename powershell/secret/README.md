# Powershell Scripts

## Set-VariablesFromKeyVault
This small script is able to load keyvault secrets to powershell variables

Prerequisites:
```powershell

# install dependency modules
Install-Module -Name Microsoft.PowerShell.SecretManagement
Install-Module -Name Microsoft.PowerShell.SecretStore

# register a new local secret store
Register-SecretVault -Name mySecretStore -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault

# create two examples secrets into local secret store
Set-Secret sp-dev-appid -Vault mySecretStore -Secret "<< service principal appid >>"
            -metadata @{"type"="service-principal";"envname"="dev";"varname"="appid"} 

Set-Secret sp-dev-secret -Vault mySecretStore -Secret "<< service principal secret >>"
            -metadata @{"type"="service-principal";"envname"="dev";"varname"="secret"}




```