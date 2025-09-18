# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dominio::fondo_linux
class dominio::fondo_linux {

  file { '/tmp/logo.jpg':
    ensure => file,
    source => 'puppet:///modules/fondo_linux/logo.jpg',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }


  # 1. Configuración de LightDM (pantalla de login)
  file { '/etc/lightdm/lightdm-gtk-greeter.conf.d/01-wallpaper.conf':
    ensure  => file,
    content => @("EOF")
      [greeter]
      background=/tmp/logo.jpg
      EOF,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  # 2. Fondo de escritorio para todos los usuarios de XFCE
  # Se aplica al "canal" xfce4-desktop
  exec { 'set-xfce-background':
    command => "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s '/tmp/logo.jpg'",
    path    => ['/bin', '/usr/bin'],
    unless  => "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path | grep '/tmp/logo.jpg'",
  }

  # 3. Bloquear cambios de fondo para usuarios (requiere que edites /etc/xdg/xfce4/xfconf/xfce-perchannel-xml)
  file { '/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml':
    ensure  => file,
    content => @("EOF")
      <?xml version="1.0" encoding="UTF-8"?>
      <channel name="xfce4-desktop" version="1.0">
        <property name="backdrop" type="empty">
          <property name="screen0" type="empty">
            <property name="monitor0" type="empty">
              <property name="image-path" type="string" value="/tmp/logo.jpg"/>
              <property name="image-show" type="bool" value="true"/>
            </property>
          </property>
        </property>
      </channel>
      EOF,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}
