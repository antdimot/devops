[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$PAT,
    [Parameter(Mandatory)]
    [int]$PipelineId,
    [string]$Organization = "<<your-organization>>",
    [string]$Project = "<<your-project>>"
)

$api_version = "6.0-preview.1"

$token = [Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$PAT"))

Import-Module .\PipeLib.psm1 -Force

try {
    $pipe = GetPipe -PAT $PAT -PipelineId $PipelineId -Organization $Organization -Project $Project

    $runListRequestParameters = @{
        Uri = "https://dev.azure.com/$Organization/$Project/_apis/pipelines/$PipelineId/runs?api-version=$api_version"
        Method = "GET"
        ContentType = "application/json"
        Headers = @{ Authorization="Basic $token" }
    }

    $runListResponse = Invoke-RestMethod @runListRequestParameters

    Write-Host "Found $($runListResponse.count) runs for pipeline $($pipe.Name)."

    $runListResponse.value | Add-Member -NotePropertyName adoLink -NotePropertyValue ""

    foreach ($item in $runListResponse.value) {
        $item.adoLink = "https://dev.azure.com/$Organization/$Project/_build/results?buildId=$($item.id)"
    }

    $runListResponse.value | Sort-Object -Descending -Property createdDate | Format-Table -Property id, state, result, createdDate, finishedDate, adoLink
}
catch {
    Write-Error $_
    exit 1
}