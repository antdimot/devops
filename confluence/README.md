# Confluence Powershell Scripts

Goal of this library is make easy create, get and update [Confluence](https://www.atlassian.com/it/software/confluence)'s page by using powershell.

## Examples
```powershell
# Define Confluence security env variables
$confluence_domain  = "https://<<your-domain>>.atlassian.net"
$confluence_user    = "your confluence-email-address"
$confluence_token   = "your api-token" 
# You can generate your api token at  https://id.atlassian.com/manage-profile/security/api-tokens
```

```powershell
# Create a new page on Confluence
Import-Module .\ConfluencePageManagement.psm1

$result = New-ConfluencePage    -Domain $confluence_domain  `
                                -User $confluence_user      `
                                -Token $confluence_token    `
                                -Space "demo"               `
                                -Title "Hello World"        `
                                -Content "This is a new page."
$result

PageId Link
------ ----
360449 https://<<your-domain>>.atlassian.net/wiki/<<tiny-ui-link>>
```

```powershell
# Get page's content from Confluence
$result = Get-ConfluencePage    -Domain $confluence_domain    `
                                -User $confluence_user        `
                                -Token $confluence_token      `
                                -PageId 360449
$result

Title   : "Hello World"
Version : 1
Space   : DEMO
Content : "This is a new page."
Status  : current
Link    : https://<<your-domain>>.atlassian.net/wiki/<<tiny-ui-link>>
```

```powershell
# Update page information on Confluence
$result = Update-ConfluencePage -Domain $confluence_domain              `
                                -User $confluence_user                  `
                                -Token $confluence_token                `
                                -PageId 360449                          `
                                -Title "Hello World Updated!"           `
                                -Content "I updated the content of page."
$result

IsOk Version Link
---- ------- ----
True       2 https://<<your-domain>>.atlassian.net/wiki/<<tiny-ui-link>>
```
