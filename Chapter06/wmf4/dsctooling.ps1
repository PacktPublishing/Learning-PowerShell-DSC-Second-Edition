############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################

function New-DscResourceArchive
{
  [CmdletBinding()]
  param(
    [string]$ModulePath,
    [string]$DestinationPath,
    [Switch]$Force
  )

  $Version     = Get-DscResourceModuleVersion -ModulePath $ModulePath
  $folderName  = $DestinationPath + "_" + $Version
  $archiveName = $executionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$folderName.zip")

  if(Test-Path $archiveName){
    if($Force){
      Remove-Item $archiveName -Force
    }
    else{
      throw "Item with specified name $archiveName already exists."
    }
  }

  if($PSVersionTable.PSVersion.Major -eq 4){
    New-ZipFile -Path $ModulePath -DestinationPath $archiveName
    New-DSCCheckSum -Path $archiveName -OutPath (Split-Path -Path $DestinationPath -Parent)
  }else{
    Compress-Archive -Path $ModulePath -DestinationPath $archiveName
  }
}

function Get-DscResourceModuleVersion
{
  [CmdletBinding()]
  param($ModulePath)

  $moduleName = Split-Path -Path $modulePath -Leaf
  Write-Verbose $ModulePath
  Write-Verbose $moduleName
  $manifest   = Get-ChildItem -Path $modulePath -Filter "$moduleName.psd1" -Recurse | Select-Object -First 1
  Write-Verbose $manifest.FullName
  if(-not (Test-Path $manifest.FullName)){
    throw "Could not find manifest.FullName in $modulePath"
  }

  $text    = Get-Content -Path $manifest.FullName -Raw
  $version = (Invoke-Expression -Command $text)['ModuleVersion']
  return $version
}

function New-ZipFile
{
  [CmdletBinding()]
  param($Path, $DestinationPath)

  [byte[]]$zipHeader = 0x50,0x4B,0x05,0x06,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
  try{
    $stream = New-Object System.IO.FileStream $DestinationPath, "Create"
    $com    = New-Object -ComObject "Shell.Application"
    $zip    = $com.namespace($DestinationPath)

    $stream.Write($zipheader, 0, 22)
    $stream.Close();
    Start-Sleep -Seconds 1

    $zip.CopyHere($Path)
    Start-Sleep -Seconds 5
  }
  finally{
    $com = $null
    $zip = $null
  }

  Write-Verbose "Created $DestinationPath"
}

function Get-DscPullServerInformation
{
  [CmdletBinding()]
  Param (
    [string] $Uri = "http://localhost:9080/PSDSCComplianceServer.svc/Status"
  )
  Write-Verbose "Querying node information from pull server URI  = $Uri"

  $invokeParams = @{
    Uri                   = $Uri
    Method                = "Get"
    ContentType           = 'application/json'
    UseDefaultCredentials = $true
    Headers               = @{Accept = 'application/json'}
  }
  $response = Invoke-WebRequest @invokeParams

  if($response.StatusCode -ne 200){
    throw "Could not access $uri"
  }

  ConvertFrom-Json $response.Content
}
