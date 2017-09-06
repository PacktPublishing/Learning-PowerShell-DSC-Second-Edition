############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################

Configuration PantheonDeployment
{
  Import-DscResource -Module PSDesiredStateConfiguration
  Import-DscResource -Module xPSDesiredStateConfiguration
  Import-DscResource -Module xRemoteDesktopAdmin
  Import-DscResource -Module xTimeZone
  Import-DscResource -Module xComputerManagement
  Import-DscResource -Module xSystemSecurity

  Node ($AllNodes).NodeName
  {
    LocalConfigurationManager
    {
      ConfigurationId           = $Node.ConfigurationId
      RefreshMode               = $Node.RefreshMode
      ConfigurationMode         = $Node.ConfigurationMode
      AllowModuleOverwrite      = $Node.AllowModuleOverwrite
      RebootNodeIfNeeded        = $Node.RebootNodeIfNeeded
      CertificateId             = $Node.CertificateId
      DownloadManagerCustomData = @{
        ServerUrl = $Node.PSDSCCPullServer;
      }
    }

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

$file   = Join-Path $PSScriptRoot 'data_example_03.psd1'
$output = Join-Path $PSScriptRoot 'PantheonDeployment'
$data   = Invoke-Expression -Command "DATA { $(Get-Content -Raw -Path $file) }"
PantheonDeployment -ConfigurationData $data -OutputPath $output
