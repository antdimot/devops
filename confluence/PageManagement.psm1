
class ConfluenceConfig {
    [PSCredential]$Credential
    [string]$ConfluenceBaseUri = "https://<<your-domain>>/confluence"

    [string]GetConfluenceBaseUriAPI(){
        return ("$($this.ConfluenceBaseUri)/rest/api/content")
    }
}

function Get-ConfluencePage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ConfluenceConfig]$Config,
        [Parameter(Mandatory)]
        [int]$PageId
    )

    try {
    
        $request_uri = "$($Config.ConfluenceBaseUri())/$($PageId)?expand=version,space,body.storage"

        $response = Invoke-RestMethod   -Method GET -ContentType 'application/json' `
                                        -Uri $request_uri -Authentication Basic `
                                        -Credential $Config.Credential

        $link = "$($Config.ConfluenceBaseUri)$($response._links.tinyui)"

        return [PSCustomObject]@{
            Title = $response.title
            Version = $response.version.number
            Space = $response.space.key
            Body = $response.body.storage
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
        [ConfluenceConfig]$Config,
        [Parameter(Mandatory)]
        [int]$PageId,
        [Parameter(Mandatory)]
        [string]$Body
    )

    try {

    $pageInfo = Get-ConfluencePageInfo -credential $Config.Credential -pageId $PageId
    $nextVersion = $pageInfo.Version + 1
    $space = $pageInfo.Space
    $title = $pageInfo.Title

    $confluencePayload = @"
    {
        "type" : "page",
        "title": "$title",
        "space":
        {
            "key": "$space"
        },
        "body":
        {
            "storage":
            {
                "value": "$body",
                "representation":"storage"
            }
        },
        "version":
        {
            "number": $nextVersion
        }
    }
"@

        $request_uri = "$($Config.ConfluenceBaseUri())/$($PageId)"

        Invoke-RestMethod   -Method PUT -ContentType 'application/json' `
                            -Uri $request_uri -Body $confluencePayload `
                            -Authentication Basic -Credential $Config.Credential | Out-Null

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
        [ConfluenceConfig]$Config,
        [Parameter(Mandatory)]
        [string]$Title,
        [Parameter(Mandatory)]
        [string]$Space,
        [Parameter(Mandatory)]
        [string]$Body
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
                    "value": "$Body",
                    "representation":"storage"
                }
            }
        }
"@

        $response = Invoke-RestMethod   -Method POST -ContentType 'application/json' `
                                        -Uri $base_uri_api -Body $confluencePayload `
                                        -Authentication Basic -Credential $Config.Credential

        $link = "$($Config.ConfluenceBaseUri)$($response._links.tinyui)"

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