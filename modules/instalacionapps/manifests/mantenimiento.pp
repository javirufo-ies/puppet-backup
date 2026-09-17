# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::mantenimiento
class instalacionapps::mantenimiento {

  # Paquetes necesarios
  package {
    [
      'unattended-upgrades',
      'apt-listchanges',
      'needrestart',
      'deborphan',
      'linux-generic',
      'linux-headers-generic',
    ]:
      ensure => installed;
  }

  # Actualizar índice de paquetes
  exec { 'apt_update':
    command => '/usr/bin/apt-get update',
    path    => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    unless  => '/usr/bin/test $(find /var/lib/apt/periodic/update-success-stamp -mtime -1 2>/dev/null | wc -l) -gt 0',
  }

  # Equivalente a dist-upgrade / full-upgrade
  exec { 'apt_full_upgrade':
    command     => '/usr/bin/apt-get -y full-upgrade',
    path        => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    refreshonly => true,
    subscribe   => Exec['apt_update'],
  }

  # Eliminación automática de paquetes obsoletos
  exec { 'apt_autoremove':
    command     => '/usr/bin/apt-get -y autoremove --purge',
    path        => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    refreshonly => true,
    subscribe   => Exec['apt_full_upgrade'],
  }

  # Eliminación automática de kernels antiguos
  exec { 'purge_old_kernels':
    command => '/bin/bash -c "apt-get -y autoremove --purge"',
    path    => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    require => Exec['apt_autoremove'],
  }

  # Configuración unattended-upgrades
  file { '/etc/apt/apt.conf.d/20auto-upgrades':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @("EOF")
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
| EOF
  }

  file { '/etc/apt/apt.conf.d/52unattended-upgrades-custom':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @("EOF")
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "03:00";
| EOF
  }

  service { 'unattended-upgrades':
    ensure    => running,
    enable    => true,
    subscribe => [
      File['/etc/apt/apt.conf.d/20auto-upgrades'],
      File['/etc/apt/apt.conf.d/52unattended-upgrades-custom']
    ],
  }

  # Mitigación temporal Copy.Fail
  file { '/etc/modprobe.d/disable-algif-aead.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "install algif_aead /bin/false\n",
  }

  exec { 'unload_algif_aead':
    command => '/usr/sbin/rmmod algif_aead',
    onlyif  => '/usr/sbin/lsmod | /usr/bin/grep -q "^algif_aead"',
    path    => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    require => File['/etc/modprobe.d/disable-algif-aead.conf'],
  }

}
