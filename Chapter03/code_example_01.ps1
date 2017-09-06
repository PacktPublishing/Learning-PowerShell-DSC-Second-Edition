Configuration InstallExampleSoftware
{
    Node "localhost"
    {
        WindowsFeature DotNet
        {
            Ensure = 'Present'
            Name   = 'NET-Framework-45-Core'
        }
    }
}
