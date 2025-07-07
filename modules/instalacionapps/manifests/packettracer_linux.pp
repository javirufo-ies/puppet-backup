# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::packettracer_linux
class instalacionapps::packettracer_linux {




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
exec { 'copiar_packet_desde_nfs':
  command => '/usr/bin/cp /tmp/nas_instaladores/Packet_Tracer822_amd64_signed.deb /tmp/packet.deb',
  creates => '/tmp/packet.deb',
  require => Mount['/tmp/nas_instaladores'],
}

exec { 'instalar_packet':
  command => 'dpkg -i /tmp/packet.deb && rm /tmp/packet.deb',
  path    => ['/bin', '/usr/bin'],
  require => Exec['copiar_packet_desde_nfs'],
}


# 4. Desmonta NFS solo si se montó antes
exec { 'desmontar_nas':
  command     => '/usr/bin/umount /tmp/nas_instaladores',
  onlyif      => '/usr/bin/mount | /usr/bin/grep /tmp/nas_instaladores',
  require     => Exec['copiar_packet_desde_nfs'],
  path        => ['/bin', '/usr/bin'],
}



}
