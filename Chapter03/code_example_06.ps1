$TheData = @{
  AllNodes = @(
    @{
      NodeName = "server1"
      Roles    = @('Foobar')
      ExampleSoftware = @{
        Name       = "ExampleSoftware"
        ProductId  = "{b652663b-867c-4d93-bc14-8ecb0b61cfb0}"
        SourcePath = "c:\packages\thesoftware.msi"
        ConfigFile = "c:\foo.txt"
      }
    },
    @{
      NodeName = "server2"
    }
  );
  NonNodeData = @{
    ConfigFileContents = (Get-Content "Config.xml")
  }
}

InstallExampleSoftware -ConfigurationData $TheData
