# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::chrome_linux

class instalacionapps::chrome_linux {

  include apt

  $keyring_path = '/usr/share/keyrings/google-linux-signing-keyring.gpg'

  # Descargar y almacenar la clave GPG sin apt-key
  exec { 'add_google_key':
    command => "/usr/bin/wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > ${keyring_path}",
    creates => $keyring_path,
  }

  apt::source { 'google-chrome':
    location => 'http://dl.google.com/linux/chrome/deb/',
    repos    => 'stable main',
    release  => '',  # Deja vacío para evitar errores con jammy, etc.
    include  => {
      src => false,
    },
    options => ["signed-by=${keyring_path}"],
    require => Exec['add_google_key'],
  }

  exec { 'apt_update_google_chrome':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
    subscribe   => Apt::Source['google-chrome'],
  }

  package { 'google-chrome-stable':
    ensure  => installed,
    require => Exec['apt_update_google_chrome'],
  }

}
