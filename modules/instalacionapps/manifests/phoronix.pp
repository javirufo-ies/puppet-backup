# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::phoronix

class instalacionapps::phoronix {

  # Asegura las dependencias necesarias
  package { ['php-cli', 'php-xml', 'gzip', 'bzip2']:
    ensure => installed,
  }

  # Descargar el .deb de Phoronix Test Suite
#  exec { 'descargar_phoronix':
#    command => 'wget -O /tmp/master.zip https://github.com/phoronix-test-suite/phoronix-test-suite/archive/refs/heads/master.zip',
#    path    => ['/usr/bin', '/bin'],
#	unless => 'test -d /usr/share/phoronix-test-suite/',
#  }

  # Ruta donde se copiará el archivo .deb en el cliente
  $master = '/tmp/master.zip'

  # 1. Copiar el archivo .deb desde el servidor Puppet al cliente
  file { $master:
    ensure => file,
    source => 'puppet:///modules/instalacionapps/master.zip',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }


  exec { 'descomprimir_phoronix':
    command     => 'unzip -o /tmp/master.zip -d  /tmp/ && rm /tmp/master.zip',
    path        => ['/usr/bin', '/bin'],
#    require     => Exec['descargar_phoronix'],
  }

  # Instalar el paquete .deb (con fallback a apt -f install para dependencias)
  exec { 'instalar_phoronix':
    command     => 'bash ./install-sh && rm -Rf /tmp/phoronix*',
	cwd => '/tmp/phoronix-test-suite-master',
# && rm /tmp/install.sh',
    path        => ['/usr/bin', '/bin'],
    refreshonly => true,
    subscribe   => Exec['descomprimir_phoronix'],
  }


}

