$outputPath = ([IO.Path]::Combine($PSScriptRoot, 'WMF4TargetNodeLCM'))
$dataScript = ([IO.Path]::Combine($PSScriptRoot, 'wmf4_config_data.ps1'))
$configData = &$dataScript

C:\vagrant\book\ch06\wmf4_target_node.ps1 -configdata $configData -output $outputPath
Set-DscLocalConfigurationManager -Path $outputPath -Verbose
