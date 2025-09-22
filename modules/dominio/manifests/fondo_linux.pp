# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dominio::fondo_linux
class dominio::fondo_linux {


  # 1️⃣ Asegurar que el directorio para LightDM exista (opcional si lo usas)
  file { '/etc/lightdm/lightdm-gtk-greeter.conf.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # 2️⃣ Copiar el fondo desde el módulo
  file { '/tmp/logo.jpg':
    ensure => file,
    source => 'puppet:///modules/dominio/logo.jpg',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # 3️⃣ Configurar Cinnamon para usar el fondo
  exec { 'set-cinnamon-background':
    command => 'gsettings set org.cinnamon.desktop.background picture-uri "file:///tmp/logo.jpg"',
    path    => ['/usr/bin', '/bin'],
    onlyif  => 'test -f /tmp/logo.jpg',
    require => File['/tmp/logo.jpg'],
  }

  # 4️⃣ Crear archivo de configuración global para dconf
  file { '/etc/dconf/db/local.d/00-fondo':
    ensure  => file,
    content => "[org/cinnamon/desktop/background]\npicture-uri='file:///tmp/logo.jpg'\npicture-options='zoom'\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/tmp/logo.jpg'],
  }

  # 5️⃣ Crear archivo de bloqueo para impedir cambios por los usuarios
  file { '/etc/dconf/db/local.d/locks/background':
    ensure  => file,
    content => "/org/cinnamon/desktop/background/picture-uri\n/org/cinnamon/desktop/background/picture-options\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/dconf/db/local.d/00-fondo'],
  }

  # 6️⃣ Actualizar la base de datos dconf para aplicar los cambios globales
  exec { 'update-dconf':
    command => '/usr/bin/dconf update',
    path    => ['/usr/bin', '/bin'],
    require => [File['/etc/dconf/db/local.d/00-fondo'], File['/etc/dconf/db/local.d/locks/background']],
  }

}
