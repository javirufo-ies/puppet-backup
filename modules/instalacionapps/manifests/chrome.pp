# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::chrome
class instalacionapps::chrome {

  include apt  # Requiere tener puppetlabs-apt instalado

# Ruta de la clave GPG convertida a keyring
$file_keyring = '/usr/share/keyrings/google-linux-signing-keyring.gpg'

# Descargar y almacenar la clave en el keyring (sin apt-key)
exec { 'add_google_key':
  command => "/usr/bin/wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | tee ${file_keyring} > /dev/null",
  creates => $file_keyring,
}


apt::source { 'google-chrome':
  location => 'http://dl.google.com/linux/chrome/deb/',
  repos    => 'stable main',
  release  => '',  # Vacío para que no ponga jammy, focal, etc.
  include  => {
    src => false,
  },
  key      => {
    id     => '',  # No hace falta si usas signed-by manual
    source => '',  # Idem
  },
#  options  => ["signed-by=${file_keyring}"],
  require  => Exec['add_google_key'],
}


  # Actualizar índice apt solo si cambia el repo
  exec { 'apt_update_google_chrome':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
    subscribe   => Apt::Source['google-chrome'],
  }

  # Instalar Google Chrome estable
  package { 'google-chrome-stable':
    ensure  => installed,
    require => Exec['apt_update_google_chrome'],
  }
}


