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
  Import-DscResource -Module xWebAdministration

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
      Name = $Node.NodeName
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
      Ensure = 'Present'
      Name   = 'Telnet-Client'
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

  Node ($AllNodes.Where({$_.Roles -contains 'WebServer'})).NodeName
  {
    WindowsFeature IIS
    {
      Ensure = 'Present'
      Name   = 'Web-Server'
    }

    WindowsFeature IISConsole
    {
      Ensure    = 'Present'
      Name      = 'Web-Mgmt-Console'
      DependsOn = '[WindowsFeature]IIS'
    }

    WindowsFeature IISScriptingTools
    {
      Ensure    = 'Present'
      Name      = 'Web-Scripting-Tools'
      DependsOn = '[WindowsFeature]IIS'
    }

    WindowsFeature AspNet
    {
      Ensure    = 'Present'
      Name      = 'Web-Asp-Net45'
      DependsOn = @('[WindowsFeature]IIS')
    }

    xWebsite DefaultSite
    {
      Ensure       = 'Present'
      Name         = 'Default Web Site'
      State        = 'Stopped'
      PhysicalPath = 'C:\inetpub\wwwroot'
      DependsOn    = @('[WindowsFeature]IIS','[WindowsFeature]AspNet')
    }

    xRemoteFile DownloadAuroraZip
    {
      Uri             = $Node.Aurora.Sourcepath
      DestinationPath = (Join-Path 'C:\Windows\Temp' (Split-Path -Path $Node.Aurora.Sourcepath -Leaf))
      DependsOn       = @('[xWebsite]DefaultSite')
    }

    xArchive AuroraZip
    {
      Path            = (Join-Path 'C:\Windows\Temp' (Split-Path -Path $Node.Aurora.Sourcepath -Leaf))
      Destination     = 'C:\Windows\Temp'
      DestinationType = 'Directory'
      MatchSource     = $true
      DependsOn       = @('[xRemoteFile]DownloadAuroraZip')
    }

    File AuroraContent
    {
      Ensure          = 'Present'
      Type            = 'Directory'
      SourcePath      = Join-Path 'C:\Windows\Temp' ([IO.Path]::GetFileNameWithoutExtension($Node.Aurora.Sourcepath))
      DestinationPath = $Node.Aurora.DestinationPath
      Recurse         = $true
      DependsOn       = '[xArchive]AuroraZip'
    }

    xWebAppPool AuroraWebAppPool
    {
      Ensure = "Present"
      State  = "Started"
      Name   = $Node.WebAppPoolName
    }

    xWebsite AuroraWebSite
    {
      Ensure       = 'Present'
      State        = 'Started'
      Name         = $Node.Aurora.WebsiteName
      PhysicalPath = $Node.Aurora.DestinationPath
      DependsOn    = '[File]AuroraContent'
    }

    xWebApplication AuroraWebApplication
    {
      Name         = $Node.Aurora.WebApplicationName
      Website      = $Node.Aurora.WebSiteName
      WebAppPool   = $Node.Aurora.WebAppPoolName
      PhysicalPath = $Node.Aurora.DestinationPath
      Ensure       = 'Present'
      DependsOn    = @('[xWebSite]AuroraWebSite')
    }
  }
}

# use data_example_05.psd1 when reading section Software Upgrades
# $file   = Join-Path $PSScriptRoot 'data_example_05.psd1'
$file   = Join-Path $PSScriptRoot 'data_example_04.psd1'
$output = Join-Path $PSScriptRoot 'PantheonDeployment'
$data   = Invoke-Expression -Command "DATA { $(Get-Content -Raw -Path $file) }"
PantheonDeployment -ConfigurationData $data -OutputPath $output
