@{
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
      Roles    = @('Foobar')
      ExampleSoftware = @{
        Name       = "ExampleSoftware"
        ProductId  = "{b652663b-867c-4d93-bc14-8ecb0b61cfb0}"
        SourcePath = "e:\packages\thesoftware.msi"
        ConfigFile = "e:\foo.txt"
      }
    },
    @{
      NodeName = "server3"
      Roles    = @('Wakka')
    }
  );
  NonNodeData = @{
    ConfigFileContents = (Get-Content "Config.xml")
  }
}
