# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::chrome_linux

class instalacionapps::chrome_linux {

  # Asegura que el módulo puppetlabs-apt está cargado
  include apt

  # Añadir el repositorio oficial de Google Chrome
  apt::source { 'google-chrome':
    location => 'https://dl.google.com/linux/chrome/deb/',
    repos    => 'stable main',
    key      => {
      'id'     => '4CCA1EAF950CEE4AB83976DCA040830F7FAC5991',
      'source' => 'https://dl.google.com/linux/linux_signing_key.pub',
    },
    include  => {
      src => false,
    },
  }

  # Instalar Google Chrome estable
  package { 'google-chrome-stable':
    ensure  => installed,
    require => Apt::Source['google-chrome'],
  }


}
