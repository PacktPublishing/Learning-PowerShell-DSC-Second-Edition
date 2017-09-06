############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################
$outputPath = ([IO.Path]::Combine($PSScriptRoot, 'SetupTheSite'))
$dataScript = ([IO.Path]::Combine($PSScriptRoot, 'https_config_data.ps1'))
$configData = &$dataScript

.\example_configuration.ps1 -outputPath $outputPath -configData $configData

if(Test-Path (Join-Path $($outputPath) 'ExampleConfiguration.mof')){
  rm (Join-Path $($outputPath) 'ExampleConfiguration.mof')
}
Rename-Item -Path (Join-Path $($outputPath) 'dsc-box2.mof') -NewName 'ExampleConfiguration.mof'

Import-Module -Name "$($env:ProgramFiles)\WindowsPowerShell\Modules\xPSDesiredStateConfiguration\6.4.0.0\DSCPullServerSetup\PublishModulesAndMofsToPullServer.psm1"

$moduleList = @("xWebAdministration", "xPSDesiredStateConfiguration")
Publish-DSCModuleAndMOF -Source $outputPath -ModuleNameList $moduleList

ls "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
ls "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
