[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$PAT,
    [Parameter(Mandatory)]
    [string]$File,
    [bool]$Simulate = $false,    
    [string]$Organization = "dimotta",
    [string]$Project = "demo"
)

$api_version = "6.0-preview.1"

$token = [Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$PAT"))

$pipeToRuns = Import-Csv -Path "$file"

foreach ( $item in $pipeToRuns )
{
    $sb = [System.Text.StringBuilder]::new()
    
    $item.parameters.Split(";") | ForEach {
        $parameter = $_.Split("=")

        [void]$sb.AppendFormat( '"{0}": "{1}",', $parameter[0], $parameter[1] )
    }

    $payload = @"
    {
        "resources": {
            "repositories": {
                "self": {
                    "refName": "$($item.branch)"
                }
            }
        },
        "templateParameters": {
            $($sb.ToString())
        }
    }
"@

    $uri ="https://dev.azure.com/$Organization/$Project/_apis/pipelines/$($item.definitionid)/runs?api-version=$api_version"
    if ($Simulate) {
        Write-Host $uri
        Write-Host $payload   
    }

    $requestParameters = @{
        Uri = $uri
        Method = "POST"
        ContentType = "application/json"
        Headers = @{ Authorization="Basic $token" }
        Body = $payload
    }

    if (-not($Simulate)) {
        $response = Invoke-RestMethod @requestParameters

        Write-Host "$($item.name) $($response.state) on $($item.branch) -> https://dev.azure.com/$Organization/$Project/_build/results?buildId=$($response.id)"
    }

}