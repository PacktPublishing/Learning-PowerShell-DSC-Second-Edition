Configuration InstallExampleSoftware
{
  param(
    $computer,
    $ExampleSoftwareName,
    $ExampleSoftwareProductId,
    $ExampleSoftwarePath,
    $ConfigFileContents
  )

  Node $computer
  {
    WindowsFeature DotNet
    {
      Ensure = 'Present'
      Name   = 'NET-Framework-45-Core'
    }

    File ConfigFile
    {
      DestinationPath = "c:\foo.txt"
      Contents        = $ConfigFileContents
    }

    Package   InstallExampleSoftware
    {
      Ensure    = "Present"
      Name      = $ExampleSoftwareName
      ProductId = $ExampleSoftwareProductId
      Path      = $ExampleSoftwarePath
      DependsOn = @('[WindowsFeature]DotNet')
    }
  }
}
