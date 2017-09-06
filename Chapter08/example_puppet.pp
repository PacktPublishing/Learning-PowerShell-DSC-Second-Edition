class pantheondeployment(
  $machinename,
  $os
){
  dsc_xcomputer{'newname':
    dsc_name => $node['machinename']
  }

  dsc_xtimezone{'utctimezone':
    dsc_timezone         => 'utc'
    dsc_issingleinstance => 'yes'
  }

  dsc_xremotedesktopadmin{'remotedesktopsettings':
    dsc_ensure             => 'present'
    dsc_userauthentication => 'nonsecure'
  }

  dsc_xieesc{'disableieescadmin':
    dsc_userrole  => 'administrators'
    dsc_isenabled => false
  }

  dsc_xieesc{'disableieescuser':
    dsc_userrole  => 'users'
    dsc_isenabled => true
  }

  dsc_xuac{'setdefaultuac':
    dsc_setting => 'notifychanges'
  }

  dsc_registry{'showfileextensions':
    dsc_ensure    => 'present'
    dsc_key       => 'HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    dsc_valuename => 'hidefileext'
    dsc_valuedata => '0'
    dsc_valuetype => 'dword'
  }

  dsc_windowsfeature{'telnetclient':
    dsc_ensure => 'present'
    dsc_name   => 'telnet-client'
  }
}
