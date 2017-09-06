############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################

Configuration PantheonDeployment
{
  Import-DscResource -Module xPSDesiredStateConfiguration
  Import-DscResource -Module xRemoteDesktopAdmin
  Import-DscResource -Module xTimeZone
  Import-DscResource -Module xComputerManagement
  Import-DscResource -Module xSystemSecurity

  Node ($AllNodes).NodeName
  {
    xComputer NewName
    {
      Name = $Node.MachineName
    }

    xTimeZone UtcTimeZone
    {
      TimeZone         = 'UTC'
      IsSingleInstance = 'Yes'
    }

    xRemoteDesktopAdmin RemoteDesktopSettings
    {
      Ensure             = 'Present'
      UserAuthentication = 'NonSecure'
    }

    xIEEsc DisableIEEscAdmin
    {
      UserRole  = 'Administrators'
      IsEnabled = $false
    }

    xIEEsc EnableIEEscUser
    {
      UserRole  = 'Users'
      IsEnabled = $true
    }

    xUac SetDefaultUAC
    {
      Setting = 'NotifyChanges'
    }

    WindowsFeature TelnetClient
    {
      Ensure = "Present"
      Name   = "Telnet-Client"
    }
  }

  Node ($AllNodes.Where({$_.Roles -contains 'appserver'})).NodeName
  {
    xPackage ApolloPackage
    {
      Ensure    = 'Present'
      Name      = $Node.Apollo.Name
      ProductId = $Node.Apollo.ProductId
      Path      = $Node.Apollo.SourcePath
      Arguments = $Node.Apollo.Arguments
    }

    File ApolloConfigFile
    {
      Ensure          = 'Present'
      Type            = 'File'
      DestinationPath = $Node.Apollo.ConfigFilePath
      Contents        = $Node.Apollo.ConfigFileContents
      DependsOn       = '[xPackage]ApolloPackage'
    }

    Service ApolloService
    {
      Name      = 'apollo'
      State     = 'Running'
      DependsOn = @("[xPackage]ApolloPackage")
    }
  }

}

$file   = Join-Path $PSScriptRoot 'data_example_02.psd1'
$output = Join-Path $PSScriptRoot 'PantheonDeployment'
$data   = Invoke-Expression -Command "DATA { $(Get-Content -Raw -Path $file) }"
PantheonDeployment -ConfigurationData $data -OutputPath $output
