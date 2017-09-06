# beginning of script
[CmdletBinding()]
param(
  [Parameter()]$OutputPath = [IO.Path]::Combine($PSScriptRoot, 'InstallExampleSoftware'),
  [Parameter()]$ConfigData
)

Configuration InstallExampleSoftware
{
  Import-DscResource -Module ExampleSoftwareDscResource
  Import-DscResource -Module RealStuffDscResource

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
    ExampleSoftwareDscResource InstallExampleSoftware
    {
      Name               = $Node.ExampleSoftware.Name
      ProductId          = $Node.ExampleSoftware.ProductId
      Path               = $Node.ExampleSoftware.SourcePath
      ConfigFile         = $Node.ExampleSoftware.ConfigFile
      ConfigFileContents = $ConfigurationData.NonNodeData.ConfigFileContents
    }
  }

  Node $AllNodes.Where({$_.Roles -contains 'RealStuff'}).NodeName
  {
    RealStuffDscResource InstallRealStuffSoftware
    {
      Name      = $Node.RealStuffSoftware.Name
      ProductId = $Node.RealStuffSoftware.ProductId
      Path      = $Node.RealStuffSoftware.Source
    }
  }

}

InstallExampleSoftware  -OutputPath $OutputPath -ConfigurationData $ConfigData
# script end
