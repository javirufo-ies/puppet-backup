# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dominio::fondo_linux
class dominio::fondo_linux {

  # Ruta destino del fondo en el sistema
  $fondo_destino = '/usr/share/backgrounds/fondo.jpg'

  ###############################
  # Copiar el fondo desde Puppet
  ###############################
  file { $fondo_destino:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dominio/fondo.jpg',
  }

  ###############################
  # Fondo de escritorio (usuarios)
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
    content => "[org/gnome/desktop/background]\n" +
               "picture-uri='file://${fondo_destino}'\n" +
               "picture-uri-dark='file://${fondo_destino}'\n",
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
    content => "/org/gnome/desktop/background/picture-uri\n" +
               "/org/gnome/desktop/background/picture-uri-dark\n",
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
  # Fondo de LightDM (pantalla de login)
  ########################################

  file { '/etc/lightdm/lightdm-gtk-greeter.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "[greeter]\nbackground=${fondo_destino}\n",
    require => File[$fondo_destino],
  }

}
