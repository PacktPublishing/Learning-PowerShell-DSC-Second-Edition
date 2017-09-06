############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################
[CmdletBinding()]
param(
  $configData,
  $outputPath = ([IO.Path]::Combine($PSScriptRoot, 'WMF4PullServer'))
)

Configuration WMF4PullServer
{
  Import-DSCResource -ModuleName xPSDesiredStateConfiguration

  Node $AllNodes.Where({ $_.Roles -contains 'PullServer'}).NodeName
  {
    WindowsFeature DSCServiceFeature
    {
      Ensure = 'Present'
      Name   = 'DSC-Service'
    }

    xDscWebService PSDSCPullServer
    {
      Ensure                       = "Present"
      EndpointName                 = $Node.PullServerEndpointName
      Port                         = $Node.PullServerPort
      PhysicalPath                 = $Node.PullServerPhysicalPath
      CertificateThumbPrint        = $Node.CertificateThumbPrint
      ModulePath                   = $Node.ModulePath
      ConfigurationPath            = $Node.ConfigurationPath
      AcceptSelfSignedCertificates = $true
      State                        = "Started"
      DependsOn                    = @("[WindowsFeature]DSCServiceFeature","[File]RegistrationKeyFile")
    }

    xDscWebService PSDSCComplianceServer
    {
      Ensure                = "Present"
      EndpointName          = $Node.ComplianceServerEndpointName
      Port                  = $Node.ComplianceServerPort
      PhysicalPath          = $Node.CompliancePhysicalPath
      CertificateThumbPrint = "AllowUnencryptedTraffic"
      IsComplianceServer    = $true
      State                 = "Started"
      DependsOn             = @("[WindowsFeature]DSCServiceFeature")
    }

    File CopyPackagedModules
    {
      Ensure          = "Present"
      Type            = "Directory"
      SourcePath      = $Node.PackagedModulePath
      DestinationPath = $Node.ModulePath
      Recurse         = $true
      DependsOn       = "[xDscWebService]PSDSCPullServer"
    }
  }
}

WMF4PullServer -ConfigurationData $configData -OutputPath $outputPath
