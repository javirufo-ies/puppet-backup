# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::openrsat
class instalacionapps::openrsat {
  # Ruta donde se copiará el archivo .deb en el cliente
  $deb_file_path = '/tmp/OpenRSAT.deb'

  # 1. Copiar el archivo .deb desde el servidor Puppet al cliente
  file { $deb_file_path:
    ensure => file,
    source => 'puppet:///modules/instalacionapps/OpenRSAT.deb',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # 2. Instalar el paquete .deb usando dpkg
  exec { 'install_openrsat':
    command     => "/usr/bin/dpkg -i ${deb_file_path}",
    path        => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    require     => File[$deb_file_path],
    unless      => '/usr/bin/dpkg -l openrsat | grep -q "^ii"',
    logoutput   => on_failure,
  }

  # 3. Corregir dependencias rotas si es necesario (después de dpkg -i)
  exec { 'fix_openrsat_dependencies':
    command     => '/usr/bin/apt-get install -f -y',
    path        => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    require     => Exec['install_openrsat'],
    refreshonly => true,
    subscribe   => Exec['install_openrsat'],
  }
}
