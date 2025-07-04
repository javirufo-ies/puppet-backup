# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::vmware_linux
class instalacionapps::vmware_linux {


  package { 'nfs-common':
    ensure => installed,
  }


# 1. Crea directorio de montaje temporal
file { '/tmp/nas_instaladores':
  ensure => 'directory',
}

# 2. Monta el recurso NFS temporalmente
mount { '/tmp/nas_instaladores':
  ensure  => 'mounted',
  device  => '10.0.0.21:/Repositorio/Instaladores',
  fstype  => 'nfs',
  options => 'ro',
  atboot  => false,
  require => File['/tmp/nas_instaladores'],
}

# 3. Copia el instalador, solo si no existe
exec { 'copiar_vmware_desde_nfs':
  command => '/usr/bin/cp /tmp/nas_instaladores/VMware-Workstation-Full-17.6.3-24583834.x86_64.bundle /tmp/VMware.bundle',
  creates => '/tmp/VMware.bundle',
  require => Mount['/tmp/nas_instaladores'],
}

exec { 'instalar_vmware':
  command => 'sh /tmp/VMware.bundle --eulas-agreed --console --required && rm /tmp/VMware.bundle',
  creates => '/usr/bin/vmware',
  path    => ['/bin', '/usr/bin'],
  require => Exec['copiar_vmware_desde_nfs'],
}


# 4. Desmonta NFS solo si se montó antes
exec { 'desmontar_nas':
  command     => '/usr/bin/umount /tmp/nas_instaladores',
  onlyif      => '/usr/bin/mount | /usr/bin/grep /tmp/nas_instaladores',
  require     => Exec['copiar_vmware_desde_nfs'],
  path        => ['/bin', '/usr/bin'],
}



}
