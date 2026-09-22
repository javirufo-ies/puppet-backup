class dominio::montaje_nas {
if $::kernel == 'windows' {

#  $nas_server  = '\\\\10.0.0.33\\Repositorio'
#  $nas_user    = 'invitado'
#  $nas_pass    = lookup('dominio::passwordinvitado')  # ← contraseña cifrada en Hiera
#
#  registry::value { 'Map R Drive to QNAP':
#    ensure => present,
#    key    => 'HKCU\\Network\\R',
#    value  => 'RemotePath',
#    type   => 'string',
#    data   => $nas_server,
#  }

#  registry::value { 'R Drive UserName':
#    ensure => present,
#    key    => 'HKCU\\Network\\R',
#    value  => 'UserName',
#    type   => 'string',
#    data   => $nas_user,
#  }

#  registry::value { 'R Drive Password':
#    ensure => present,
#    key    => 'HKCU\\Network\\R',
#    value  => 'Password',
#    type   => 'string',
#    data   => $nas_pass,
#  }
#
#  registry::value { 'R Drive ProviderName':
#    ensure => present,
#    key    => 'HKCU\\Network\\R',
#    value  => 'ProviderName',
#    type   => 'string',
#    data   => 'Microsoft Windows Network',
#  }


}
else {

	package {'pam-mount':
		ensure => latest,
	}
	package {'cifs-utils':
		ensure => latest,
	}
	package {'keyutils':
		ensure => latest,
	}

	file {'/etc/profile.d/enlace_nas.sh':
		ensure => absent,
	}



  file { '/etc/security/pam_mount.conf.xml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @("EOF")
<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE pam_mount SYSTEM "pam_mount.conf.xml.dtd">

<pam_mount>

  <debug enable="0" />

  <mntoptions allow="nosuid,nodev,loop,encryption,fsck,nonempty,allow_root,allow_other" />
  <mntoptions require="nosuid,nodev" />

  <logout wait="0" hup="no" term="no" kill="no" />

  <mkmountpoint enable="1" remove="true" />

  <volume
      user="*"
      fstype="cifs"
      server="10.0.0.33"
      path="Repositorio"
      mountpoint="/home/%(USER)/Repositorio"
      options="sec=krb5,cruid=%(USERUID),vers=3.1.1,nosuid,nodev,iocharset=utf8"
  />

</pam_mount>
EOF
    require => Package['pam-mount'],
  }

  file_line { 'pam_mount_common_auth':
    path  => '/etc/pam.d/common-auth',
    line  => 'auth optional pam_mount.so',
    match => '^auth.*pam_mount\.so',
    require => Package['pam-mount'],
  }

  file_line { 'pam_mount_common_session':
    path  => '/etc/pam.d/common-session',
    line  => 'session optional pam_mount.so',
    match => '^session.*pam_mount\.so',
    require => Package['pam-mount'],
  }




#Fin else
}
#Fin clase
}
