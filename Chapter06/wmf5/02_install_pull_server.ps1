############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################

$outputPath = ([IO.Path]::Combine($PSScriptRoot, 'HTTPSPullServer'))
$dataScript = ([IO.Path]::Combine($PSScriptRoot, 'https_config_data.ps1'))
$configData = &$dataScript

.\https_dsc_pull_server.ps1 -OutputPath $outputPath -ConfigData $configData
Start-DscConfiguration -Path $outputPath -Wait -Verbose -Force

