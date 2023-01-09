<#
	.Synopsis
  	Load secrets from KeyVault and set it as powershell variable.

 	.Description
  	Create powershell variables with secret information retrieved from KeyVault

 	.Parameter Envname
  	Environment name (metadata.envname).

	.Parameter Envname
  	Vault name.
#>
function Set-VariablesFromKeyVault {
	param(
		[Parameter(Mandatory=$true)]
		[string] $envname,
		[Parameter(Mandatory=$true)]
		[string] $vaultname 
	)

	$vault_items = get-secretinfo -vault $vaultname | where-object { $_.metadata.envname -eq $envname }

	try {
		$vault_items | foreach-object {
			$new_var_name = $envname + "_" + $_.metadata.varname
	
			$new_var_value = get-secret $_.name -vault $vaultname -asplaintext
	
			set-variable -name $new_var_name -value $new_var_value -scope global
		}
	}
	catch {
		Write-Error $_
	}
}

<#
	.Synopsis
  	Clean powershell variables.

 	.Description
  	Remove powershell variables.

 	.Parameter Envname
  	Environment name (metadata.envname).

	.Parameter Envname
  	Vault name.
#>
function Remove-VariablesByKeyVault {
	param(
		[Parameter(Mandatory=$true)]
		[string] $envname,
		[Parameter(Mandatory=$true)]
		[string] $vaultname 
	)

	$vault_items = get-secretinfo -vault $vaultname | where-object { $_.metadata.envname -eq $envname }

	try {
		$vault_items | foreach-object {
			$old_var_name = $envname + "_" + $_.metadata.varname
	
			remove-variable -name $old_var_name -scope global
		}
	}
	catch {
		Write-Error $_
	}
}

Export-ModuleMember -Function Set-VariablesFromKeyVault
Export-ModuleMember -Function Remove-VariablesByKeyVault