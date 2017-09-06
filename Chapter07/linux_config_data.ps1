$cert = Get-ChildItem -Path Cert:\LocalMachine\Root\ | ? { $_.Subject -eq 'CN=dsc-box1' }

$configData = @{
  AllNodes = @(
    @{
      NodeName               = "*"
      RegistrationKey        = 'c4729623-1eb7-408a-b3f4-fbddcc63e703'
      ConfigurationServerURL = "https://dsc-box1:8080/PSDSCPullServer.svc"
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
      RegistrationKeyFile          = 'RegistrationKeys.txt'
      RegistrationKeyPath          = "$env:PROGRAMFILES\WindowsPowerShell\DscService"
      ModulePath                   = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
      ConfigurationPath            = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
      PullServerEndpointName       = 'PSDSCPullServer'
      PullServerPhysicalPath       = "$env:SystemDrive\inetpub\PSDSCPullServer"
      PullServerPort               = 8080
    },
    @{
      NodeName              = 'dsc-box2'
      Roles                 = @('Linux')
      ImportantFile         = "/tmp/dsctest"
      ImportantFileContents = "This is my DSC Test!"
    }
  );
}

return $configData
