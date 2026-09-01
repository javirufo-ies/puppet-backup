class dominio::unirdominio (
  String $dominio       = 'ciclos.valledeljerte3',
  String $realm         = 'CICLOS.VALLEDELJERTE3',
  String $ad_user       = lookup('dominio::usuario'),
  String $ad_password   = lookup('dominio::password'),
) {



 if $::kernel == 'windows' {





  file { 'C:/tmp/unirdominio.ps1':
    ensure  => file,
    content => template('dominio/unirdominio.ps1.erb'),
    mode    => '0777',
  }

  exec { 'join_domain':
    command   => 'powershell.exe -ExecutionPolicy Bypass -NoProfile -File C:/tmp/unirdominio.ps1',
    unless => 'powershell.exe -Command "if ((Get-WmiObject Win32_ComputerSystem).PartOfDomain) { exit 0 } else { exit 1 }"',
    provider  => powershell,
    logoutput => false,
    require   => File['C:/tmp/unirdominio.ps1'],
   notify    => Exec['borrarunion_ad'],
}

exec { 'borrarunion_ad':
  command  => 'powershell.exe -Command "Remove-Item -Path c:/tmp/unirdominio.ps1 -Force"',
  provider => powershell,
  refreshonly => true,
}




 } else {

  package { [
    'realmd', 'sssd', 'sssd-tools', 'libnss-sss', 'libpam-sss',
    'adcli', 'oddjob', 'oddjob-mkhomedir', 'krb5-user',
    'samba-common-bin', 'packagekit'
  ]:
    ensure => installed,
  }

  service { 'oddjobd':
    ensure => running,
    enable => true,
  }

  file_line { 'pam_mkhomedir':
    path  => '/etc/pam.d/common-session',
    line  => 'session required pam_mkhomedir.so skel=/etc/skel/ umask=0022',
    match => '^session\s+required\s+pam_mkhomedir\.so',
  }

# $ad_password_real = $ad_password.unwrap
#  exec { 'join-domain':
#    command => "/usr/bin/echo '${ad_password}' | /usr/sbin/realm join --user=${ad_user}@${realm} ${dominio} --verbose",
#    unless  => "/usr/sbin/realm list | grep -i '${dominio}'",
#    path    => ['/usr/bin', '/usr/sbin'],
#    require => Package['realmd'],
#  }


$ad_password_real = $ad_password.unwrap

# Unir al dominio solo si no está unido O si la unión está rota
exec { 'join-domain':
  command => "/usr/bin/echo '${ad_password_real}' | /usr/sbin/realm join --user=${ad_user}@${realm} ${dominio} --verbose",
  onlyif  => "/bin/bash -c '! /usr/sbin/realm list | grep -qi \"${dominio}\" || ! /usr/bin/id testuser@${realm} >/dev/null 2>&1'",
  path    => ['/usr/bin', '/usr/sbin', '/bin'],
  require => Package['realmd'],
}

# Si el join falla (porque ya estaba unido pero roto), hacer leave primero
exec { 'leave-domain-if-broken':
  command => '/usr/sbin/realm leave',
  onlyif  => "/bin/bash -c '/usr/sbin/realm list | grep -qi \"${dominio}\" && ! /usr/bin/id testuser@${realm} >/dev/null 2>&1'",
  path    => ['/usr/bin', '/usr/sbin', '/bin'],
  before  => Exec['join-domain'],
  require => Package['realmd'],
}



  exec { 'generate-keytab':
    command => "/usr/sbin/adcli keytab --domain=${dominio} --computer-name=$(hostname -s) --login-user=${ad_user}@${realm} --login-password=${ad_password} /etc/krb5.keytab",
    unless  => "/usr/bin/test -f /etc/krb5.keytab",
    require => Exec['join-domain'],
  }

  file { '/etc/sssd/sssd.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => epp('dominio/sssd.conf.epp', { 'dominio' => $dominio }),
    require => Exec['generate-keytab'],
  }

  service { 'sssd':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/sssd/sssd.conf'],
  }



$fqdn = $facts['networking']['fqdn']
$ip   = $facts['networking']['ip']

file { '/etc/nsupdate.txt':
  ensure  => file,
  content => "update delete ${fqdn} A\nupdate add ${fqdn} 3600 A ${ip}\nsend\n",
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

exec { 'actualizar_dns':
  command => "/usr/bin/kinit -k HOST/${fqdn}@CICLOS.VALLEDELJERTE3 && /usr/bin/nsupdate -g /etc/nsupdate.txt",
  path    => ['/usr/bin', '/usr/sbin'],
  unless  => "/usr/bin/nslookup ${fqdn} | grep -q ${ip}",
  require => File['/etc/nsupdate.txt'],
}




#Vamos a añadir el script que permite añadir a los usuarios al grupo vboxusers para que puedan usar usb
#Crear el grupo vboxusers si no existe
  group { 'vboxusers':
    ensure => present,
  }





# Crear el archivo con el contenido
file { '/usr/local/bin/anade_vboxusers.sh':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
	source => "puppet:///modules/dominio/anade_vboxusers.sh",
}


#Configurar PAM para ejecutar el script en common-session
  exec { 'anadir_pam_hook_common_session':
    command => "echo 'session optional pam_exec.so /usr/local/bin/anade_vboxusers.sh' >> /etc/pam.d/common-session",
    unless  => "grep -q 'pam_exec.so /usr/local/bin/anade_vboxusers.sh' /etc/pam.d/common-session",
    path    => ['/bin', '/usr/bin'],
    require => File['/usr/local/bin/anade_vboxusers.sh'],
  }

#Configurar PAM para ejecutar el script en LightDM
  exec { 'add_pam_hook_lightdm':
    command => "echo 'session optional pam_exec.so /usr/local/bin/anade_vboxusers.sh' >> /etc/pam.d/lightdm",
    unless  => "grep -q 'pam_exec.so /usr/local/bin/anade_vboxusers.sh' /etc/pam.d/lightdm",
    path    => ['/bin', '/usr/bin'],
    require => File['/usr/local/bin/anade_vboxusers.sh'],
  }







 }
}
