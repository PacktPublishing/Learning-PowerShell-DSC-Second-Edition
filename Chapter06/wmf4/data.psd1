@{
  AllNodes = @(
    @{
      NodeName                     = 'dsc-box1'

      CertificateThumbPrint        = $cert.ThumbPrint
      AcceptSelfSignedCertificates = $true

      RegistrationKey              = 'c4729623-1eb7-408a-b3f4-fbddcc63e703'
      RegistrationKeyFile          = 'RegistrationKeys.txt'
      RegistrationKeyPath          = "$env:PROGRAMFILES\WindowsPowerShell\DscService"
      ModulePath                   = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
      ConfigurationPath            = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"

      PullServerEndpointName       = 'PSDSCPullServer'
      PullServerPhysicalPath       = "$env:SystemDrive\inetpub\PSDSCPullServer"
      PullServerPort               = 8080

      ReportingServerEndpointName  = 'PSDSCReportingServer'
      ReportingPhysicalPath        = "$env:SystemDrive\inetpub\PSDSCReportingServer"
      ReportingServerPort          = 9080
    },
    @{
      NodeName               = 'dsc-box2'
      RefreshMode            = 'PULL'
      CertificateID          = $cert.ThumbPrint
      RegistrationKey        = 'c4729623-1eb7-408a-b3f4-fbddcc63e703'
      ConfigurationServerURL = 'https://dsc-box1:8080/PSDSCPullServer.svc'
      ReportServerURL        = 'https://dsc-box1:9080/PSDSCReportingServer.svc'
      ConfigurationMode      = 'ApplyAndAutocorrect'
      AllowModuleOverwrite   = $true
      RebootNodeIfNeeded     = $true
    }
  );
}
