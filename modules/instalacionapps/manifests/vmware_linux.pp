# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::vmware_linux
class instalacionapps::vmware_linux {

  # Asegura dependencias para compilar módulos kernel
  package { ['gcc', 'make', "linux-headers-${facts['kernelrelease']}"]:
    ensure => installed,
  }

  # Copiar el instalador desde el NAS usando SCP
  exec { 'copiar_instalador_vmware':
    command => 'scp nasuser@192.168.1.100:/export/software/VMware-Workstation-FULL.bundle /tmp/VMware.bundle',
    creates => '/tmp/VMware.bundle',
    path    => ['/bin', '/usr/bin'],
  }

  # Instalar VMware (solo si no está instalado ya)
  exec { 'instalar_vmware':
    command => '/tmp/VMware.bundle --eulas-agreed --required --console',
    path    => ['/bin', '/usr/bin'],
    creates => '/usr/bin/vmware',
    require => [
      Package['gcc'],
      Exec['copiar_instalador_vmware'],
    ],
  }

}
