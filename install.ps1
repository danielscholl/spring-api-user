<#
.SYNOPSIS
  Install the Infrastructure As Code Solution
.DESCRIPTION
  This Script will install the Infrastructure.

  1. Resource Group
  2. Cosmos DB

.EXAMPLE
  .\install.ps1
  Version History
  v1.0   - Initial Release
#>
#Requires -Version 6.2.1
#Requires -Module @{ModuleName='Az.Resources'; ModuleVersion='1.7.1'}

Param(
  [string]$Subscription = $env:ARM_SUBSCRIPTION_ID,
  [string]$Initials = $env:PROJECT_CONTACT,
  [string]$ResourceGroupName,
  [string]$Location = $env:AZURE_LOCATION,
  [string]$ServicePrincipalAppId = $env:AZURE_USER_ID,
  [string]$ContainerName = $env:PROJECT_CONTAINER,
  [string]$PartitionKey = $env:PROJECT_CONTAINER_PARTITION,
  [boolean]$Show = $false
)

. .env.ps1
Get-ChildItem Env:ARM*
Get-ChildItem Env:AZURE*
Get-ChildItem Env:PROJECT*
Get-ChildItem Env:cosmosdb*

if ( !$Initials) { $Initials = "spring" }

###############################
## FUNCTIONS                 ##
###############################
function Write-Color([String[]]$Text, [ConsoleColor[]]$Color = "White", [int]$StartTab = 0, [int] $LinesBefore = 0, [int] $LinesAfter = 0, [string] $LogFile = "", $TimeFormat = "yyyy-MM-dd HH:mm:ss") {
  # version 0.2
  # - added logging to file
  # version 0.1
  # - first draft
  #
  # Notes:
  # - TimeFormat https://msdn.microsoft.com/en-us/library/8kb3ddd4.aspx

  $DefaultColor = $Color[0]
  if ($LinesBefore -ne 0) { for ($i = 0; $i -lt $LinesBefore; $i++) { Write-Host "`n" -NoNewline } } # Add empty line before
  if ($StartTab -ne 0) { for ($i = 0; $i -lt $StartTab; $i++) { Write-Host "`t" -NoNewLine } }  # Add TABS before text
  if ($Color.Count -ge $Text.Count) {
    for ($i = 0; $i -lt $Text.Length; $i++) { Write-Host $Text[$i] -ForegroundColor $Color[$i] -NoNewLine }
  }
  else {
    for ($i = 0; $i -lt $Color.Length ; $i++) { Write-Host $Text[$i] -ForegroundColor $Color[$i] -NoNewLine }
    for ($i = $Color.Length; $i -lt $Text.Length; $i++) { Write-Host $Text[$i] -ForegroundColor $DefaultColor -NoNewLine }
  }
  Write-Host
  if ($LinesAfter -ne 0) { for ($i = 0; $i -lt $LinesAfter; $i++) { Write-Host "`n" } }  # Add empty line after
  if ($LogFile -ne "") {
    $TextToFile = ""
    for ($i = 0; $i -lt $Text.Length; $i++) {
      $TextToFile += $Text[$i]
    }
    Write-Output "[$([datetime]::Now.ToString($TimeFormat))]$TextToFile" | Out-File $LogFile -Encoding unicode -Append
  }
}

function Get-ScriptDirectory {
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  Split-Path $Invocation.MyCommand.Path
}

function LoginAzure() {
  Write-Color -Text "Logging in and setting subscription..." -Color Green
  if ([string]::IsNullOrEmpty($(Get-AzContext).Account.Id)) {
    if ($env:ARM_CLIENT_ID) {

      $securePwd = $env:ARM_CLIENT_SECRET | ConvertTo-SecureString
      $pscredential = New-Object System.Management.Automation.PSCredential -ArgumentList $env:ARM_CLIENT_ID, $securePwd
      Connect-AzAccount -ServicePrincipal -Credential $pscredential -TenantId $tenantId

      Login-AzAccount -TenantId $env:AZURE_TENANT
    }
    else {
      Connect-AzAccount
    }
  }
  Set-AzContext -SubscriptionId $env:ARM_SUBSCRIPTION_ID | Out-null
}

function CreateResourceGroup([string]$ResourceGroupName, [string]$Location) {
  # Required Argument $1 = RESOURCE_GROUP
  # Required Argument $2 = LOCATION

  $group = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
  if ($group) {
    Write-Color -Text "Resource Group ", "$ResourceGroupName ", "already exists." -Color Green, Red, Green
  }
  else {
    Write-Host "Creating Resource Group $ResourceGroupName..." -ForegroundColor Yellow

    $UNIQUE = Get-Random -Minimum 100 -Maximum 999
    New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Tag @{ RANDOM = $UNIQUE; contact = $Initials }
  }
}

function ResourceProvider([string]$ProviderNamespace) {
  # Required Argument $1 = RESOURCE

  $result = Get-AzResourceProvider -ProviderNamespace $ProviderNamespace | Where-Object -Property RegistrationState -eq "Registered"

  if ($result) {
    Write-Color -Text "Provider ", "$ProviderNamespace ", "already registered." -Color Green, Red, Green
  }
  else {
    Write-Host "Registering Provider $ProviderNamespace..." -ForegroundColor Yellow
    Register-AzResourceProvider -ProviderNamespace $ProviderNamespace
  }
}


###############################
## Environment               ##
###############################

if ($Show -eq $true) {
  Write-Host "---------------------------------------------" -ForegroundColor "blue"
  Write-Host "Environment Loaded!!!!!" -ForegroundColor "red"
  Write-Host "---------------------------------------------" -ForegroundColor "blue"
  exit
}

if ( !$Subscription) { throw "Subscription Required" }
if ( !$Location) { throw "Location Required" }


###############################
## Azure Initialize           ##
###############################
$BASE_DIR = Get-ScriptDirectory
$DEPLOYMENT = Split-Path $BASE_DIR -Leaf
LoginAzure


if ( !$ResourceGroupName) { $ResourceGroupName = "$Initials-$DEPLOYMENT" }

$UNIQUE = CreateResourceGroup $ResourceGroupName $Location

ResourceProvider Microsoft.DocumentDB
ResourceProvider Microsoft.Web


##############################
## Deploy Template          ##
##############################
Write-Color -Text "`r`n---------------------------------------------------- "-Color Yellow
Write-Color -Text "Deploying ", "$DEPLOYMENT ", "template..." -Color Green, Red, Green
Write-Color -Text "---------------------------------------------------- "-Color Yellow
New-AzResourceGroupDeployment -Name $DEPLOYMENT `
  -TemplateFile $BASE_DIR\iac\arm\azuredeploy.json `
  -TemplateParameterFile $BASE_DIR\iac\arm\azuredeploy.parameters.json `
  -initials $INITIALS `
  -random $(Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue -WarningAction SilentlyContinue).Tags.RANDOM `
  -databaseName $DEPLOYMENT `
  -ResourceGroupName $ResourceGroupName
