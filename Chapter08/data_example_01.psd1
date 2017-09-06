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
    },
    @{
      NodeName        = 'app02'
      ConfigurationId = '8e8f44e6-aaac-4060-b072-c9ae780ee5f7'
    },
    @{
      NodeName             = '*'
      RefreshMode          = 'Push'
      ConfigurationMode    = 'ApplyAndAutoCorrect'
      AllowModuleOverwrite = $true
      RebootNodeIfNeeded   = $true
    }
  )
}
