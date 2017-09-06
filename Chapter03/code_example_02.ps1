# data file
@{
  AllNodes = @(
    @{
      NodeName = "server1"
    },
    @{
      NodeName = "server2"
    }
  );
  NonNodeData = @{
    ConfigFileContents = (Get-Content "Config.xml")
  }
}
# end of data file

# beginning of the example configuration
Configuration InstallExampleSoftware
{
  Node $AllNodes.NodeName
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
  }
}
# ending of the example configuration
