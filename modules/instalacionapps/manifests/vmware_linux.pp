# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::vmware_linux
class instalacionapps::vmware_linux {

  package { ['gcc', 'make', "linux-headers-${facts['kernelrelease']}"]:
    ensure => installed,
  }

  $bundle_path = '/tmp/VMware.bundle'

  file { $bundle_path:
    source => 'puppet:///modules/instalacionapps/VMware-Workstation-FULL.bundle',
    mode   => '0755',
  }

  exec { 'instalar_vmware':
    command => "$bundle_path --eulas-agreed --required --console",
    path    => ['/bin', '/usr/bin'],
    creates => '/usr/bin/vmware',
    require => [
      Package['gcc'],
      File[$bundle_path],
    ],
  }
}
