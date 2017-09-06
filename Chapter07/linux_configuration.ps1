############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################
[CmdletBinding()]
param(
  $configData,
  $outputPath = ([IO.Path]::Combine($PSScriptRoot, 'LinuxDemoSetup'))
)

Configuration LinuxDemoSetup {
  Import-DSCResource -Module nx
  Import-DSCResource -ModuleName xPSDesiredStateConfiguration

  Node $AllNodes.Where({ $_.Roles -contains 'Linux'}).NodeName
  {
    nxFile myTestFile
    {
      Ensure          = "Present"
      Type            = "File"
      DestinationPath = $Node.ImportantFile
      Contents        = $Node.ImportantFileContents
    }
  }

  Node $AllNodes.Where({ $_.Roles -contains 'PullServer'}).NodeName
  {
    WindowsFeature DSCServiceFeature
    {
      Ensure = 'Present'
      Name   = 'DSC-Service'
    }

    File RegistrationKeyFile
    {
      Ensure          = 'Present'
      DestinationPath = (Join-Path $Node.RegistrationKeyPath $Node.RegistrationKeyFile)
      Contents        = $Node.RegistrationKey
      DependsOn       = @("[WindowsFeature]DSCServiceFeature")
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
      RegistrationKeyPath          = $Node.RegistrationKeyPath
      AcceptSelfSignedCertificates = $true
      UseSecurityBestPractices     = $true
      State                        = "Started"
      DependsOn                    = @("[WindowsFeature]DSCServiceFeature","[File]RegistrationKeyFile")
    }
  }
}

LinuxDemoSetup -ConfigurationData $configData -OutputPath $outputPath
