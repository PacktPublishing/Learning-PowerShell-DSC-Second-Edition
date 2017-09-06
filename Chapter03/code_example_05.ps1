# beginning of script
[CmdletBinding()]
param(
  [Parameter()]$OutputPath = [IO.Path]::Combine($PSScriptRoot, 'InstallExampleSoftware'),
  [Parameter()]$ConfigData
)

Configuration InstallExampleSoftware
{
  Node $AllNodes.NodeName
  {

    WindowsFeature DotNet
    {
      Ensure = 'Present'
      Name   = 'NET-Framework-45-Core'
    }
  }

  Node $AllNodes.Where({$_.Roles -contains 'FooBar'}).NodeName
  {
    Environment AppEnvVariable
    {
      Ensure = 'Present'
      Name   = 'ConfigFileLocation'
      Value  = $Node.ExampleSoftware.ConfigFile
    }

    File ConfigFile
    {
      DestinationPath = $Node.ExampleSoftware.ConfigFile
      Contents        = $ConfigurationData.NonNodeData.ConfigFileContents
    }

    Package  InstallExampleSoftware
    {
      Ensure    = 'Present'
      Name      = $Node.ExampleSoftware.Name
      ProductId = $Node.ExampleSoftware.ProductId
      Path      = $Node.ExampleSoftware.SourcePath
      DependsOn = @('[WindowsFeature]DotNet')
    }
  }
}

InstallExampleSoftware  -OutputPath $OutputPath -ConfigurationData $ConfigData
# script end
