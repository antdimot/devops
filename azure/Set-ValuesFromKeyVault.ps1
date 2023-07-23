[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$FileName
)

$keyVaultRegexPattern = '@Microsoft\.KeyVault\(SecretUri=(.+?)\)'
$secretUriPattern = 'SecretUri=([^)]+)'

$jsonContent = Get-Content -Path $FileName -Raw -ErrorAction Stop

$jsonObject = ConvertFrom-Json $jsonContent

# recursive function for retrieving secret values
function Set-SecretPlaceholders($object) {
    foreach ($property in $object.PSObject.Properties) {
        $propertyValue = $property.Value

        # Check if the property value is an object (nested property)
        if ($propertyValue -is [System.Management.Automation.PSCustomObject]) {
            Set-SecretPlaceholders $propertyValue
        } else {
            # If the property value is not an object, check for a match with the regex pattern
            if ($propertyValue -match $keyVaultRegexPattern) {
                # Write-Output "Matched value for property '$($property.Name)': $propertyValue"
                $secreUriMatches = $propertyValue | Select-String -Pattern $secretUriPattern

                if ($secreUriMatches.Matches.Count -gt 0) {
                    $secretUri = $secreUriMatches.Matches[0].Groups[1].Value
                    # Write-Host "Extracted SecretUri: $secretUri"
                    $secret = Get-AzKeyVaultSecret -VaultName (Get-AzKeyVault -Name (Split-Path $secretUri -Parent)).VaultName -Name (Split-Path $secretUri -Leaf)
                    $secretValue = ConvertFrom-SecureString $secret.SecretValue -AsPlainText
                    # Write-Host "Secret Value: $secretValue"
                    $property.Value = $secretValue
                }
            }
        }
    }
}

Set-SecretPlaceholders $jsonObject

# $jsonObject
$json = $jsonObject | ConvertTo-Json

# save result file
Set-Content -Path "out.json" -Value $json | Out-Null