# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::linux_lts
class instalacionapps::linux_lts {
  package { [
    'ubuntu-release-upgrader-core',
    'screen',
  ]:
    ensure => installed,
  }

  file { '/etc/update-manager/release-upgrades':
    ensure  => file,
    content => @("EOF")
[DEFAULT]
Prompt=lts
| EOF
  }

  file { '/etc/apt/apt.conf.d/99release-upgrade-noninteractive':
    ensure  => file,
    content => @("EOF")
DPkg::Options {
 "--force-confdef";
 "--force-confold";
}
| EOF
  }

  exec { 'pre_upgrade':
    command => '/usr/bin/apt-get update && /usr/bin/apt-get -y full-upgrade && /usr/bin/apt-get -y autoremove --purge',
    path    => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    unless  => '/usr/bin/test -f /var/lib/upgrade-to-2604.done',
  }

  exec { 'upgrade_to_2604':
    command => '/bin/bash -c "export DEBIAN_FRONTEND=noninteractive && do-release-upgrade -f DistUpgradeViewNonInteractive"',
    path    => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    timeout => 0,
    require => [
      Exec['pre_upgrade'],
      File['/etc/update-manager/release-upgrades'],
      File['/etc/apt/apt.conf.d/99release-upgrade-noninteractive'],
    ],
    creates => '/var/lib/upgrade-to-2604.done',
  }

  exec { 'mark_upgrade_done':
    command     => '/usr/bin/touch /var/lib/upgrade-to-2604.done',
    refreshonly => true,
    subscribe   => Exec['upgrade_to_2604'],
  }

}
