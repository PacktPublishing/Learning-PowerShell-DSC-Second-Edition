###begin script###
$data = @{
  AllNodes = @(
    @{ NodeName = 'localhost' },
    @{ NodeName = '192.168.0.13' }
  )
}

Configuration SetupAllTheThings
{
  Node $AllNodes.NodeName
  {
    File CreateFile
    {
      Ensure          = "Present"
      DestinationPath = "c:\test.txt"
      Contents        = "Wakka"
    }
  }
}

[IO.Path]::Combine($PSScriptRoot, "SetupAllTheThings")
SetupAllTheThings -ConfiurationData $data -OutputPath $mofPath
###end script###
