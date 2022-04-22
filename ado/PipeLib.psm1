$api_version = "6.0-preview.1"

function GetPipe {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$PAT,
        [Parameter(Mandatory)]
        [int]$PipelineId,
        [string]$Organization = "<<your-organization>>",
        [string]$Project = "<<your-project>>"
    )

    $token = [Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$PAT"))

    try {
        $request = @{
            Uri = "https://dev.azure.com/$Organization/$Project/_apis/pipelines/$($PipelineId)?api-version=$api_version"
            Method = "GET"
            ContentType = "application/json"
            Headers = @{ Authorization="Basic $token" }
        }

        $response = Invoke-RestMethod @request

        return [PSCustomObject]@{    
            Id = $response.id
            Name = $response.name
            Link = "https://dev.azure.com/$Organization/$Project/_build?definitionId=$($PipelineId)"
        }
    }
    catch {
        Write-Error $_
        exit 1
    }
}