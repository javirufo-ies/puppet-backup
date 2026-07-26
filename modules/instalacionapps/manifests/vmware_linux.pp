# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::vmware_linux
class instalacionapps::vmware_linux {
  
  # 1. Paquetes necesarios para compilar
  package { ["build-essential", "linux-headers-${facts['kernelrelease']}", "dkms"]:
    ensure => installed,
  }

  # 2. Copiar instalador
  exec { 'copiar_vmware':
    command => "smbclient //10.0.0.33/Repositorio -N -c 'cd Instaladores; get VMware-Workstation-Full-17.6.3-24583834.x86_64.bundle /tmp/VMware.bundle'",
    creates => '/tmp/VMware.bundle',
    path    => ['/usr/bin', '/bin', '/usr/sbin'],
  }

  # 3. Instalar VMware
  exec { 'instalar_vmware':
    command => 'sh /tmp/VMware.bundle --eulas-agreed --console --required && rm -f /tmp/VMware.bundle',
    creates => '/usr/bin/vmware',
    path    => ['/bin', '/usr/bin'],
    require => Exec['copiar_vmware'],
  }

  # 4. Compilar los módulos
  exec { 'compilar_modulos':
    command => '/usr/bin/vmware-modconfig --console --install-all',
    # ELIMINADO: refreshonly => true (si no, nunca se ejecuta por sí solo)
    # MEJORA: Usar el fact de Puppet en lugar de $(uname -r) para evitar problemas de shell
    unless  => "/usr/bin/test -f /lib/modules/${facts['kernelrelease']}/misc/vmmon.ko",
    require => Exec['instalar_vmware'],
  }

  # 5. Cargar el módulo vmmon (CORREGIDO)
  exec { 'cargar_vmmon':
    command => '/sbin/modprobe vmmon',
    unless  => '/sbin/lsmod | grep -q vmmon',
    require => Exec['compilar_modulos'],
  }

}
