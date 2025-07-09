# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::vscode_linux
class instalacionapps::vscode_linux {

  # Asegurarse de que los paquetes necesarios estén instalados
  package { ['apt-transport-https']:
    ensure => installed,
  }

  # Crear el directorio para llaveros si no existe
  file { '/usr/share/keyrings':
    ensure => directory,
    mode   => '0755',
  }

  # Descargar y desarmar la clave GPG de Microsoft
  exec { 'descargar_clave_microsoft':
    command => 'wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg',
    creates => '/usr/share/keyrings/microsoft.gpg',
    require => Package['wget'],
  }

  # Crear el archivo de repositorio APT con signed-by
  file { '/etc/apt/sources.list.d/vscode.list':
    ensure  => file,
    content => 'deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main',
    mode    => '0644',
    require => Exec['descargar_clave_microsoft'],
  }

  # Ejecutar apt-get update si cambia el archivo de repositorio
  exec { 'apt_update_vscode':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
    subscribe   => File['/etc/apt/sources.list.d/vscode.list'],
  }

  # Instalar Visual Studio Code
  package { 'code':
    ensure  => installed,
    require => Exec['apt_update_vscode'],
  }
}
