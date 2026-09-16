# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::packettracer_linux
class instalacionapps::packettracer_linux {

  package {
    [
      'gdebi',
      'libgl1-mesa-dri',
      'libgl1',
      'sudo',
      'dialog',
      'xdg-utils',
      'gtk-update-icon-cache',
      'libglx-mesa0',
      'libpulse0',
      'libnss3',
      'libxss1',
      'libasound2t64',
      'libxslt1.1',
      'libxkbcommon-x11-0',
      'libxcb-xinerama0',
      'debconf-utils',
    ]:
      ensure => installed,
  }

  exec { 'copiar_packet':
    command => "smbclient //10.0.0.21/Repositorio -N -c 'cd Instaladores; get Packet_Tracer822_amd64_signed.deb /tmp/packet.deb; get libegl1-mesa_23.0.4-0ubuntu1.22.04.1_amd64.deb /tmp/libegl1-mesa.deb; get libgl1-mesa-glx_23.0.4-0ubuntu1.22.04.1_amd64.deb /tmp/libgl1-mesa-glx.deb'",
    creates => '/tmp/packet.deb',
    path    => ['/usr/bin', '/bin'],
    require => Package['smbclient'],
  }

  exec { 'packettracer_eula':
    command => "/bin/sh -c \"echo 'PacketTracer_822_amd64 PacketTracer_822_amd64/accept-eula boolean true' | debconf-set-selections\"",
    path    => ['/usr/bin', '/bin'],
    require => Exec['copiar_packet'],
  }

  exec { 'instalar_packet':
    command => 'apt-get install -y /tmp/libegl1-mesa_23.0.4-0ubuntu1.22.04.1_amd64.deb /tmp/libgl1-mesa-glx_23.0.4-0ubuntu1.22.04.1_amd64.deb /tmp/packet.deb',
    environment => [
      'DEBIAN_FRONTEND=noninteractive',
      'APT_LISTCHANGES_FRONTEND=none',
    ],
    path    => ['/usr/bin', '/bin', '/usr/sbin'],
    unless  => '/usr/bin/dpkg -s PacketTracer >/dev/null 2>&1',
    require => Exec['packettracer_eula'],
  }

  exec { 'limpiar_packet':
    command     => '/bin/rm -f /tmp/packet.deb /tmp/libegl1-mesa.deb /tmp/libgl1-mesa-glx.deb',
    refreshonly => true,
    subscribe   => Exec['instalar_packet'],
    path        => ['/usr/bin', '/bin'],
  }

}
