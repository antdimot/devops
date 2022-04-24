
function Get-ConfluencePage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$User,
        [Parameter(Mandatory)]
        [string]$Token,
        [Parameter(Mandatory)]
        [string]$Domain, # "https://<<your-domain>>.atlassian.net"
        [Parameter(Mandatory)]
        [int]$PageId
    )

    try {
        $token = [Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($User):$($Token)"))

        $request = @{
            Uri = "$($Domain)/wiki/rest/api/content/$($PageId)?expand=version,space,body.storage"
            Method = "GET"
            ContentType = "application/json"
            Headers = @{ Authorization="Basic $token" }
        }

        $response = Invoke-RestMethod @request

        $link = "$($Domain)/wiki$($response._links.tinyui)"

        return [PSCustomObject]@{
            Title = $response.title
            Version = $response.version.number
            Space = $response.space.key
            Content = $response.body.storage.value
            Status = $response.status
            Link = $link
        }
    }
    catch {
        Write-Error $_
        exit 1
    }
}

function Update-ConfluencePage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$User,
        [Parameter(Mandatory)]
        [string]$Token,
        [Parameter(Mandatory)]
        [string]$Domain, # "https://<<your-domain>>.atlassian.net"
        [Parameter(Mandatory)]
        [int]$PageId,
        [string]$Title,      
        [string]$Content
    )

    try {

    $pageInfo = Get-ConfluencePage  -Domain $Domain `
                                    -User $User     `
                                    -Token $Token   `
                                    -PageId $PageId

    $nextVersion = $pageInfo.Version + 1
    $space = $pageInfo.Space

    $newTitle = ( [string]::IsNullOrEmpty($Title) ? $pageInfo.Title : $Title )
    $newContent = ( [string]::IsNullOrEmpty($Content) ? $pageInfo.Content : $Content )

    $confluencePayload = @"
    {
        "type" : "page",
        "title": "$newTitle",
        "space":
        {
            "key": "$space"
        },
        "body":
        {
            "storage":
            {
                "value": "$newContent",
                "representation":"storage"
            }
        },
        "version":
        {
            "number": $nextVersion
        }
    }
"@

        $token = [Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($User):$($Token)"))

        $request = @{
            Uri = "$($Domain)/wiki/rest/api/content/$($PageId)"
            Method = "PUT"
            ContentType = "application/json"
            Headers = @{ Authorization="Basic $token" }
            Body =  $confluencePayload
        }

        Invoke-RestMethod @request | Out-Null

        return [PSCustomObject]@{    
            IsOk = $true      
            Version = $nextVersion
            Link = $pageInfo.Link
        }
    }
    catch {
        Write-Error $_
        exit 1
    }
}

function New-ConfluencePage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$User,
        [Parameter(Mandatory)]
        [string]$Token,
        [Parameter(Mandatory)]
        [string]$Domain, # "https://<<your-domain>>.atlassian.net"
        [Parameter(Mandatory)]
        [string]$Title,
        [Parameter(Mandatory)]
        [string]$Space,
        [Parameter(Mandatory)]
        [string]$Content
    )

    try {
        $confluencePayload = @"
        {
            "type" : "page",
            "title": "$Title",
            "space":
            {
                "key": "$Space"
            },
            "body":
            {
                "storage":
                {
                    "value": "$Content",
                    "representation":"storage"
                }
            }
        }
"@

        $token = [Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($User):$($Token)"))

        $request = @{
            Uri = "$($Domain)/wiki/rest/api/content"
            Method = "POST"
            ContentType = "application/json"
            Headers = @{ Authorization="Basic $token" }
            Body =  $confluencePayload
        }

        $response = Invoke-RestMethod @request

        $link = "$($Domain)/wiki$($response._links.tinyui)"

        return [PSCustomObject]@{    
            PageId = $response.id
            Link = $link
        }
    }
    catch {
        Write-Error $_
        exit 1
    }    
}