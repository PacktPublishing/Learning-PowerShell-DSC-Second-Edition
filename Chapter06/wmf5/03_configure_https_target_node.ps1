############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################

$outputPath = ([IO.Path]::Combine($PSScriptRoot, 'HTTPSTargetNodeLCM'))
$dataScript = ([IO.Path]::Combine($PSScriptRoot, 'https_config_data.ps1'))
$configData = &$dataScript

.\https_target_node.ps1 -configdata $configData -output $outputPath
Set-DscLocalConfigurationManager -Path $outputPath -Verbose
