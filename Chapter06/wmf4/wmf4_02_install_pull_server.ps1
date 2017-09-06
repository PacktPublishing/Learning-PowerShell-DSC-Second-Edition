$dataScript = ([IO.Path]::Combine($PSScriptRoot, 'wmf4_config_data.ps1'))
$configData = &$dataScript

c:\vagrant\book\ch06\wmf4_pull_server.ps1 -OutputPath ([IO.Path]::Combine($PSScriptRoot, 'WMF4PullServer')) -ConfigData $configData

Start-DscConfiguration -Path ([IO.Path]::Combine($PSScriptRoot, 'WMF4PullServer')) -Wait -Verbose -Force
