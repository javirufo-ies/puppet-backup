# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dominio::fondo_linux
class dominio::fondo_linux {

  $fondo_destino = '/usr/share/backgrounds/fondo.jpg'

  # Contenido de dconf para el fondo de escritorio
  $dconf_content = "
[org/gnome/desktop/background]
picture-uri='file://${fondo_destino}'
picture-uri-dark='file://${fondo_destino}'
  "

  $dconf_locks = "
    /org/gnome/desktop/background/picture-uri
    /org/gnome/desktop/background/picture-uri-dark
"

  # Contenido de lightdm.conf para forzar greeter
  $lightdm_seat_conf = "
    [Seat:*]
    greeter-session=lightdm-gtk-greeter
  "

  # Contenido del greeter.conf para el fondo
  $lightdm_greeter_conf = "
    [greeter]
    background=${fondo_destino}
   "

  ###############################
  # Copiar el fondo desde Puppet
  ###############################
  file { $fondo_destino:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dominio/logo.jpg',
  }

  ###############################
  # Fondo de escritorio GNOME
  ###############################
  file { '/etc/dconf/db/local.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/dconf/db/local.d/00-background':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $dconf_content,
  }

  file { '/etc/dconf/db/local.d/locks':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/dconf/db/local.d/locks/background':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $dconf_locks,
  }

  exec { 'dconf_update_users':
    command     => '/usr/bin/dconf update',
    refreshonly => true,
    subscribe   => [
      File[$fondo_destino],
      File['/etc/dconf/db/local.d/00-background'],
      File['/etc/dconf/db/local.d/locks/background'],
    ],
  }

  ########################################
  # Fondo LightDM (pantalla de login)
  ########################################
  file { '/etc/lightdm/lightdm.conf.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/lightdm/lightdm.conf.d/99-mybackground.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $lightdm_seat_conf,
  }

  file { '/etc/lightdm/lightdm-gtk-greeter.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $lightdm_greeter_conf,
    require => File[$fondo_destino],
  }

}
