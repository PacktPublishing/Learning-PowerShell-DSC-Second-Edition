############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################
[CmdletBinding()]
param(
  $configData,
  $outputPath = ([IO.Path]::Combine($PSScriptRoot, 'WMF4TargetNodeLCM'))
)

Configuration WMF4TargetNodeLCM
{
  Node $AllNodes.Where({ $_.Roles -contains 'Target'}).NodeName
  {
    LocalConfigurationManager
    {
      ConfigurationId     = $Node.ConfigurationId
      RefreshMode         = $Node.RefreshMode
      ConfigurationMode   = $Node.ConfigurationMode
      DownloadManagerName = 'WebDownloadManager'
      DownloadManagerCustomData = @{
        ServerURL     = $Node.ConfigurationServerURL
        CertificateID = $Node.CertificateID
      }
    }
  }
}

WMF4TargetNodeLCM -ConfigurationData $configData -OutputPath $outputPath
