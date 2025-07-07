# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::chrome_linux

class instalacionapps::chrome_fallback {

  $key_file = '/usr/share/keyrings/google.gpg'

  # Descargar y almacenar la clave
  exec { 'add_google_key':
    command => "/usr/bin/wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > ${key_file}",
    creates => $key_file,
  }

  # Añadir repo manualmente a sources.list.d
  file { '/etc/apt/sources.list.d/google-chrome.list':
    ensure  => file,
    content => "deb [signed-by=${key_file}] http://dl.google.com/linux/chrome/deb/ stable main\n",
    require => Exec['add_google_key'],
  }

  # Actualizar índices
  exec { 'apt_update_chrome':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
    subscribe   => File['/etc/apt/sources.list.d/google-chrome.list'],
  }

  # Instalar el paquete
  package { 'google-chrome-stable':
    ensure  => installed,
    require => Exec['apt_update_chrome'],
  }
}
