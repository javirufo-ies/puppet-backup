# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::actualizaciones_linux
class instalacionapps::actualizaciones_linux {

  $codename = $facts['os']['distro']['codename']

  package { [
    'unattended-upgrades',
    'apt-listchanges',
  ]:
    ensure => installed,
  }

  file { '/etc/apt/apt.conf.d/20auto-upgrades':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @("EOF")
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
| EOF
    ,
    require => Package['unattended-upgrades'],
  }

  file { '/etc/apt/apt.conf.d/50unattended-upgrades':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @("EOF")
Unattended-Upgrade::Origins-Pattern {
        "origin=Ubuntu,codename=${codename}";
        "origin=Ubuntu,codename=${codename}-security";
        "origin=Ubuntu,codename=${codename}-updates";
        "origin=Ubuntu,codename=${codename}-backports";
};

Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";

Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-WithUsers "false";
Unattended-Upgrade::Automatic-Reboot-Time "03:00";

Unattended-Upgrade::MailReport "only-on-error";
| EOF
    ,
    require => Package['unattended-upgrades'],
  }

  service { [
    'apt-daily.timer',
    'apt-daily-upgrade.timer',
  ]:
    ensure => running,
    enable => true,
  }

  exec { 'reload-systemd':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }

  File['/etc/apt/apt.conf.d/20auto-upgrades']
    ~> Exec['reload-systemd']

  File['/etc/apt/apt.conf.d/50unattended-upgrades']
    ~> Exec['reload-systemd']

}
