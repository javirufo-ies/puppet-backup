# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::phoronix

class instalacionapps::phoronix {

  # Asegura las dependencias necesarias
  package { ['php-cli', 'gzip', 'bzip2']:
    ensure => installed,
  }

  # Descargar el .deb de Phoronix Test Suite
  exec { 'descargar_phoronix':
    command => 'wget -O /tmp/master.zip https://github.com/phoronix-test-suite/phoronix-test-suite/archive/refs/heads/master.zip',
    path    => ['/usr/bin', '/bin'],
  }

  exec { 'descomprimir_phoronix':
    command     => 'unzip /tmp/master.zip',
    creates     => '/tmp/phoronix-test-suite-master',
    path        => ['/usr/bin', '/bin'],
    require     => Exec['descargar_phoronix'],
  }

  # Instalar el paquete .deb (con fallback a apt -f install para dependencias)
  exec { 'instalar_phoronix':
    command     => 'bash /tmp/phoronix-test-suite-master/install.sh',
# && rm /tmp/install.sh',
    path        => ['/usr/bin', '/bin'],
    refreshonly => true,
    subscribe   => Exec['descomprimir_phoronix'],
  }


}

