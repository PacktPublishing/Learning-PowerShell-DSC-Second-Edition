$cert = Get-ChildItem -Path Cert:\LocalMachine\Root\ | ? { $_.Subject -eq 'CN=dsc-box1' }

$configData = @{
  AllNodes = @(
    @{
      NodeName               = "*"
      PackagedModulePath     = 'c:\Modules'
      ConfigurationServerURL = "https://dsc-box1:8080/PSDSCPullServer.svc"
      ComplianceServerURL    = "http://dsc-box1:9080/PSDSCComplianceServer.svc"
      CertificateID          = "$($cert.ThumbPrint)"
      RefreshMode            = "PULL"
      ConfigurationMode      = "ApplyAndAutocorrect"
      AllowModuleOverwrite   = $true
      RebootNodeIfNeeded     = $true
    },
    @{
      NodeName                     = 'dsc-box1'
      Roles                        = @('PullServer')
      AcceptSelfSignedCertificates = $true
      CertificateThumbPrint        = "$($cert.ThumbPrint)"
      ModulePath                   = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
      ConfigurationPath            = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
      PullServerEndpointName       = 'PSDSCPullServer'
      PullServerPhysicalPath       = "$env:SystemDrive\inetpub\PSDSCPullServer"
      PullServerPort               = 8080
      ComplianceServerEndpointName = 'PSDSCComplianceServer'
      CompliancePhysicalPath       = "$env:SystemDrive\inetpub\PSDSCComplianceServer"
      ComplianceServerPort         = 9080
    },
    @{
      NodeName        = 'dsc-box2'
      Roles           = @('Target')
      ConfigurationId = 'c19fbe22-b664-4a8a-a2a1-477f16ce9659'
      WebSiteFolder   = 'C:\testsite'
      IndexFile       = 'C:\testsite\index.html'
      WebSiteName     = 'TestSite'
      WebContentText  = '<h1>Hello World</h1>'
      WebProtocol     = 'HTTP'
      Port            = '80'
    }
  );
}

return $configData
