# Azure KeyVault Powershell Script

## Set-ValuesFromKeyVault

Goal of this script is replace all references to keyvault secret id with the corresponding secret values into a json file.

### Example

We want replace the keyvault references into the following json file:
```json
{
  "parent-property1": "@Microsoft.KeyVault(SecretUri=https://<<your-keyvault-resource>>.vault.azure.net/secrets/<<your-secret1>>)",
  "Values":
  {    
    "nested-property2": "@Microsoft.KeyVault(SecretUri=https://<<your-keyvault-resource>>.vault.azure.net/secrets/<<your-secret2>>)",
    "nested-property3": "@Microsoft.KeyVault(SecretUri=https://<<your-keyvault-resource>>.vault.azure.net/secrets/<<your-secret3>>)",
    "non-keyvault-binding-property": "<<any-value>>"
  }
}
```

To do that, first establish a connection to an Azure account and than execute the powershell script as reported below: 

```powershell
# connect to azure
Connect-AzAccount

# 
./Set-ValuesFromKeyVault.ps1 -FileName data.json
```
The result will be a new json file called out.json within the secrets replaced as this:
```json
{
  "parent-property1": "<<your-secret1-value>>",
  "Values":
  {    
    "nested-property2": "<<your-secret2-value>>",
    "nested-property3": "<<your-secret3-value>>",
    "non-keyvault-binding-property": "<<any-value>>"
  }
}
```
