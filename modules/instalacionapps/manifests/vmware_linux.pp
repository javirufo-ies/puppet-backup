# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::vmware_linux
class instalacionapps::vmware_linux {
 # 1. Paquetes necesarios para compilar
package { ['build-essential', "linux-headers-$(fact('kernelrelease'))", 'dkms']:
	ensure => installed,
}



exec { 'copiar_vmware':
	command => "smbclient //10.0.0.21/Repositorio -N -c 'cd Instaladores; get VMware-Workstation-Full-17.6.3-24583834.x86_64.bundle /tmp/VMware.bundle'",
	creates => '/tmp/VMware.bundle',
	path =>	['/usr/bin', '/bin'],
}


exec { 'instalar_vmware':
  command => 'sh /tmp/VMware.bundle --eulas-agreed --console --required && rm /tmp/VMware.bundle',
  creates => '/usr/bin/vmware',
  path    => ['/bin', '/usr/bin'],
  require => Exec['copiar_vmware'],
}

# 3. Compilar los módulos
  exec { 'compilar_modulos':
    command => '/usr/bin/vmware-modconfig --console --install-all',
    refreshonly => true,
#    subscribe   => Exec['instalar_vmware'],
  }

  # 4. Verificar que el módulo vmmon está cargado
  exec { 'comprueba_vmmon':
    command => '/usr/sbin/lsmod | grep -q vmmon',
    unless  => '/usr/sbin/lsmod | grep -q vmmon',
    require => Exec['compilar_modulos'],
  }



}
