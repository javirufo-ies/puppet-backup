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
    command => 'wget -O /tmp/phoronix-test-suite.deb https://phoronix-test-suite.com/releases/phoronix-test-suite_10.8.4_all.deb',
    creates => '/tmp/phoronix-test-suite.deb',
    path    => ['/usr/bin', '/bin'],
  }

  # Instalar el paquete .deb (con fallback a apt -f install para dependencias)
  exec { 'instalar_phoronix':
    command     => 'dpkg -i /tmp/phoronix-test-suite.deb || apt -f install -y',
    path        => ['/usr/bin', '/bin'],
    refreshonly => true,
    subscribe   => Exec['descargar_phoronix'],
  }

  # Verificar instalación
  exec { 'comprobar_phoronix':
    command => 'phoronix-test-suite version',
    path    => ['/usr/bin', '/bin'],
    unless  => 'which phoronix-test-suite',
  }

}

