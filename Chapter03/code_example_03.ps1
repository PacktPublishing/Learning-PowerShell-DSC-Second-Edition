Configuration InstallExampleSoftware
{
  Node $AllNodes.Where({$_.Roles -contains 'FooBar'}).NodeName
  {
    WindowsFeature DotNet
    {
      Ensure = 'Present'
      Name   = 'NET-Framework-45-Core'
    }

    File ConfigFile
    {
      DestinationPath = "c:\foo.txt"
      Contents        = $ConfigurationData.NonNodeData.ConfigFileContents
    }

    Package   InstallExampleSoftware
    {
      Ensure    = "Present"
      Name      = $Node.ExampleSoftware.Name
      ProductId = $Node.ExampleSoftware.ProductId
      Path      = $Node.ExampleSoftware.SourcePath
      DependsOn = @('[WindowsFeature]DotNet')
    }
  }
}
