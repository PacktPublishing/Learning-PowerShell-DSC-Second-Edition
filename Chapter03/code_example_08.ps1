[CmdletBinding()]
param(
  [Parameter()]$OutputPath = [IO.Path]::Combine($PSScriptRoot, 'InstallExampleSoftware'),
  [Parameter()]$ConfigData
)

Configuration ImportantSoftwareConfig
{
  param($ConfigFile, $ConfigFileContents)

  Environment AppEnvVariable
  {
    Ensure = 'Present'
    Name   = 'ConfigFileLocation'
    Value  = $ConfigFile
  }

  File ConfigFile
  {
    DestinationPath = $ConfigFile
    Contents        = $ConfigFileContents
  }
}

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
    ImportantSoftwareConfig SetImportantValues
    {
      ConfigFile         = $Node.ExampleSoftware.ConfigFile
      ConfigFileContents = $ConfigurationData.NonNodeData.ConfigFileContents
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
