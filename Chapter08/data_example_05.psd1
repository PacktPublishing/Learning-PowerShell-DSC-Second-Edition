############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################

@{
  AllNodes = @(
    @{
      NodeName        = 'app01'
      ConfigurationId = 'ab2c2cb2-67a3-444c-bc55-cc2ee70e3d0c'
      OS              = '2008R2'
      Roles           = @('appserver')
      Apollo = @{
        Name               = 'Apollo'
        ProductId          = '{e70c4829-91dc-4f0e-a404-4eba81f6feb9}'
        SourcePath         = 'http://build.pantheon.net/apollo/packages/releases/apollo.1.1.0.msi'
        Arguments          = ''
        ConfigFilePath     = "c:\ProgramFiles\Apollo\config\app.config"
        ConfigFileContents = "importantsetting=`$true"
      }
    },
    @{
      NodeName        = 'app02'
      ConfigurationId = '8e8f44e6-aaac-4060-b072-c9ae780ee5f7'
      OS              = '2012R2'
      Roles           = @('appserver')
    },
    @{
      NodeName        = 'app03'
      ConfigurationId = 'c880da2b-1438-4554-8c96-0e89d2f009c4'
      OS              = '2012R2'
      Roles           = @('appserver')
    },
    @{
      NodeName        = 'web01'
      ConfigurationId = 'b808fb65-5b16-4f83-84c6-aa398a6abdd5'
      OS              = '2012R2'
      Roles           = @('webserver')
    },
    @{
      NodeName        = 'web02'
      ConfigurationId = '2173f5d7-7343-4a16-a8a8-5188f2d1cdb0'
      OS              = '2012R2'
      Roles           = @('webserver')
    },
    @{
      NodeName             = '*'
      RefreshMode          = 'Pull'
      ConfigurationMode    = 'ApplyAndAutoCorrect'
      PSDSCCPullServer     = 'https://dsc01:8080/PSDSCPullServer.svc'
      AllowModuleOverwrite = $true
      RebootNodeIfNeeded   = $true
      Apollo   = @{
        Name               = 'Apollo'
        ProductId          = '{e70c4829-91dc-4f0e-a404-4eba81f6feb9}'
        SourcePath         = 'http://build.pantheon.net/apollo/packages/releases/apollo.1.1.0.msi'
        Arguments          = ''
        ConfigFilePath     = "c:\ProgramFiles\Apollo\config\app.config"
        ConfigFileContents = "importantsetting=`$true"
      }
      Aurora = @{
        SourcePath         = 'http://build.pantheon.net/aurora/releases/aurora.zip'
        DestinationPath    = "c:\inetpub\www\aurora"
        WebApplicationName = 'Aurora'
        WebSiteName        = 'Aurora'
        WebAppPoolName     = 'AuroraAppPool'
      }
    }
  )
}
