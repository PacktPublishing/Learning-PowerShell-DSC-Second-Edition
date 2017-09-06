## This is only required if you are using test machines that are not joined to the domain
## or are using IPAddresses to resolve hostnames
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value * -Force -Verbose
# Set-Item -Path WSMan:\localhost\Client\AllowUnencrypted -Value true -Force -Verbose

## This is only required if did not add rules to allow the website ports. In production add
## firewall rules for the PSDSCPullServer and PSDSCReportingServer website ports
Set-NetFirewallProfile -All -Enabled false -Verbose

## if you are using test machines that cannot resolve each other's hostnames
if (-not (Select-String -Path 'C:\Windows\System32\drivers\etc\hosts' -Pattern '192.168.50.2')) {
  Add-Content -Path C:\Windows\System32\drivers\etc\hosts -Value "`n192.168.50.2`tdsc-box1"
  Add-Content -Path C:\Windows\System32\drivers\etc\hosts -Value "`n192.168.50.4`tdsc-box2"
}

Install-Package -Name nx -Force -Verbose -ForceBootstrap
Install-Package -Name xPSDesiredStateConfiguration -Force -Verbose -ForceBootstrap

$outputPath = ([IO.Path]::Combine($PSScriptRoot, 'LinuxDemoSetup'))
$dataScript = ([IO.Path]::Combine($PSScriptRoot, 'linux_config_data.ps1'))
$configData = &$dataScript

.\linux_configuration.ps1 -OutputPath $outputPath -ConfigData $configData

$password   = "vagrant" | ConvertTo-SecureString -asPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential('root',$password)
$CIOpt      = New-CimSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck -Encoding Utf8 -UseSsl
$CimSession = New-CimSession -Authentication Basic -Credential $credential -ComputerName 'dsc-box2' -port 5986 -SessionOption $CIOpt

Get-CimInstance -CimSession $CimSession -namespace root/omi -ClassName omi_identify

Start-DscConfiguration -CimSession $CimSession -wait -Verbose -Path $outputPath

Get-DscConfiguration -CimSession $CimSession

Test-DscConfiguration -CimSession:$CimSession
