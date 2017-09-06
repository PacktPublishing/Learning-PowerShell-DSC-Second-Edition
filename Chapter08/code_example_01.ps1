############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################

Configuration PantheonDeployment
{
  Import-DscResource -Module xRemoteDesktopAdmin
  Import-DscResource -Module xTimeZone
  Import-DscResource -Module xComputerManagement
  Import-DscResource -Module xSystemSecurity

  Node ($AllNodes).NodeName
  {
    LocalConfigurationManager
    {
      ConfigurationId      = $Node.ConfigurationId
      RefreshMode          = $Node.RefreshMode
      ConfigurationMode    = $Node.ConfigurationMode
      AllowModuleOverwrite = $Node.AllowModuleOverwrite
      RebootNodeIfNeeded   = $Node.RebootNodeIfNeeded
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
}

$file   = Join-Path $PSScriptRoot 'data_example_01.psd1'
$output = Join-Path $PSScriptRoot 'PantheonDeployment'
$data   = Invoke-Expression -Command "DATA { $(Get-Content -Raw -Path $file) }"
PantheonDeployment -ConfigurationData $data -OutputPath $output
