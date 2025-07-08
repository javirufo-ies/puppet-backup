# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::vscode_linux
class instalacionapps::vscode_linux {

  include apt

  # Añadir la clave GPG de Microsoft
  apt::key { 'microsoft':
    id     => 'BC528686B50D79E339D3721CEB3E94ADBE1229CF',
    source => 'https://packages.microsoft.com/keys/microsoft.asc',
  }

  # Añadir el repositorio APT
  apt::source { 'vscode':
    location => 'https://packages.microsoft.com/repos/code',
    repos    => 'main',
    release  => 'stable',
    include  => {
      src => false,
    },
    key      => 'microsoft',
    require  => Apt::Key['microsoft'],
  }

  # Actualizar solo si cambia el repo
  exec { 'apt_update_vscode':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
    subscribe   => Apt::Source['vscode'],
  }

  # Instalar Visual Studio Code
  package { 'code':
    ensure  => installed,
    require => Exec['apt_update_vscode'],
  }

}
