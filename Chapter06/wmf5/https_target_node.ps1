############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################
[CmdletBinding()]
param(
  $configData,
  $outputPath = ([IO.Path]::Combine($PSScriptRoot, 'HTTPSTargetNodeLCM'))
)

[DscLocalConfigurationManager()]
Configuration HTTPSTargetNodeLCM
{
  Node $AllNodes.Where({ $_.Roles -contains 'Target'}).NodeName
  {
    Settings
    {
      RefreshMode          = $Node.RefreshMode
      ConfigurationMode    = $Node.ConfigurationMode
      CertificateID        = $Node.CertificateID
      RebootNodeIfNeeded   = $Node.RebootNodeIfNeeded
      AllowModuleOverwrite = $Node.AllowModuleOverwrite
    }

    ConfigurationRepositoryWeb ConfigurationManager
    {
      ServerURL       = $Node.ConfigurationServerURL
      RegistrationKey = $Node.RegistrationKey
      CertificateID   = $Node.CertificateID
      ConfigurationNames = @('ExampleConfiguration')
    }

    ReportServerWeb ReportManager
    {
      ServerURL               = $Node.ConfigurationServerURL
    }
  }
}

HTTPSTargetNodeLCM -ConfigurationData $configData -OutputPath $outputPath
