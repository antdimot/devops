# Powershell Confluence Scripts

Goal of this library is make easy get, update and create Confluence's pages by using powershell.

### Examples
```powershell
# Define Confluence security env variables
$confluence_domain  = "https://<<your-domain>>.atlassian.net"
$confluence_user    = "your confluence email address"
$confluence_token   = "your api token" # https://id.atlassian.com/manage-profile/security/api-tokens
```

```powershell
# Create a new page on Confluence
Import-Module .\ConfluencePageManagement.psm1

$result = New-ConfluencePage    -Domain $confluence_domain  `
                                -User $confluence_user      `
                                -Token $confluence_token    `
                                -Space "demo"               `
                                -Title "New Page"           `
                                -Content "This is a new page."
```

```powershell
# Get page's content from Confluence
Import-Module .\ConfluencePageManagement.psm1

$result = Get-ConfluencePage    -Domain $confluence_domain    `
                                -User $confluence_user        `
                                -Token $confluence_token      `
                                -PageId 33032
```

```powershell
# Update page information on Confluence
Import-Module .\ConfluencePageManagement.psm1

$result = Update-ConfluencePage -Domain $confluence_domain  `
                                -User $confluence_user      `
                                -Token $confluence_token    `
                                -PageId 33032               `
                                -Title "Hello World"        `
                                -Content "Its only for test."
```