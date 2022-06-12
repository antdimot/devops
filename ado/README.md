# Azure Devops Powershell Scripts

## Bulkrun

Goal of this script is run a set of ado pipeline by using a single powershell's command.

The script uses Azure Devops API rest and it requires a [Personal Access Token](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows)

### Example
```yaml
# Step 1: Create the pipeline on Azure Devops with following yaml code. Below an example with parameters.

parameters:
  - name: name
    displayName: "Name"
    type: string
  - name: surname
    displayName: "Surname"
    type: string

pool:
  vmImage: ubuntu-latest

steps:
- script: echo Hello ${{ parameters.name }} ${{ parameters.surname }}
  displayName: 'Run a one-line script'
```  

```powershell
# Step 2: Create a pipeline definition file (pipetorun.csv) with the information to run an ado pipeline for each row.
# The definitionid is the definitionid of Azure Devops pipeline
# Branch is the pipeline's branch.
# Parameters are defined as a dictionary (key=value separate by semicolon, key is equal the pipeline parameter name)

definitionid,name,branch,parameters
12,hello,main,name=Alan;surname=Turing
12,hello,main,name=Clude;surname=Shannon
12,hello,main,name=Tim;surname=Berners-Lee
12,hello,main,name=Edsger;surname=Dijkstra
12,hello,main,name=Leslie;surname=Lamport

# Step 3: Run five pipeline by using the script and the defintion file. (How to create a PAT )

.\BulkRun.ps1 -PAT personal-access-token -File .\pipetorun.csv

# Result

hello inProgress on main -> https://dev.azure.com/dimotta/demo/_build/results?buildId=119
hello inProgress on main -> https://dev.azure.com/dimotta/demo/_build/results?buildId=120
hello inProgress on main -> https://dev.azure.com/dimotta/demo/_build/results?buildId=121
hello inProgress on main -> https://dev.azure.com/dimotta/demo/_build/results?buildId=122
hello inProgress on main -> https://dev.azure.com/dimotta/demo/_build/results?buildId=123
```