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

  Node $AllNodes.Where({$_.Roles -contains 'RealStuff'}).NodeName
  {
    WindowsFeature IIS
    {
      Ensure = 'Present'
      Name   = 'Web-Server'
    }

    WindowsFeature IISConsole
    {
      Ensure    = 'Present'
      Name      = 'Web-Mgmt-Console'
      DependsOn = '[WindowsFeature]IIS'
    }

    WindowsFeature IISScriptingTools
    {
      Ensure    = 'Present'
      Name      = 'Web-Scripting-Tools'
      DependsOn = @('[WindowsFeature]IIS','[WindowsFeature]IISConsole')
    }

    WindowsFeature AspNet
    {
      Ensure    = 'Present'
      Name      = 'Web-Asp-Net'
      DependsOn = @('[WindowsFeature]IIS')
    }

    Package  InstallRealStuffSoftware
    {
      Ensure    = 'Present'
      Name      = $Node.RealStuffSoftware.Name
      ProductId = $Node.RealStuffSoftware.ProductId
      Path      = $Node.RealStuffSoftware.SourcePath
      DependsOn = @('[WindowsFeature]IIS', '[WindowsFeature]AspNet')
    }
  }

}

InstallExampleSoftware  -OutputPath $OutputPath -ConfigurationData $ConfigData
# script end
