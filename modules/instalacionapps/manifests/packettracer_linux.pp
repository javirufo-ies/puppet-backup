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
    command => "smbclient //10.0.0.21/Repositorio -N -c 'cd Instaladores; get Packet_Tracer822_amd64_signed.deb /tmp/Packet_Tracer822_amd64_signed.deb; get libegl1-mesa_23.0.4-0ubuntu1.22.04.1_amd64.deb /tmp/libegl1-mesa.deb; get libgl1-mesa-glx_23.0.4-0ubuntu1.22.04.1_amd64.deb /tmp/libgl1-mesa-glx.deb'",
    creates => '/tmp/Packet_Tracer822_amd64_signed.deb',
    path    => ['/usr/bin', '/bin'],
    require => Package['smbclient'],
  }

  exec { 'packettracer_eula':
    command => "/bin/sh -c \"echo 'PacketTracer_822_amd64 PacketTracer_822_amd64/accept-eula boolean true' | debconf-set-selections\"",
    path    => ['/usr/bin', '/bin'],
    require => Exec['copiar_packet'],
  }



exec { 'fix_dpkg':
  command => '/usr/bin/dpkg --configure -a',
  path    => ['/usr/bin','/usr/sbin','/bin'],
}

exec { 'fix_broken_packages':
  command     => '/usr/bin/apt-get -y -f install',
  environment => [
    'DEBIAN_FRONTEND=noninteractive',
  ],
  path        => ['/usr/bin','/usr/sbin','/bin'],
  require     => Exec['fix_dpkg'],
}

exec { 'remove_broken_packettracer':
  command => '/usr/bin/dpkg --remove --force-remove-reinstreq packettracer || true',
  path    => ['/usr/bin','/usr/sbin','/bin'],
  onlyif  => '/usr/bin/dpkg -l packettracer 2>/dev/null | grep -q "^iF\|^r"',
  require => Exec['fix_broken_packages'],
}

exec { 'instalar_packet':
  command => '/usr/bin/apt-get install -y /tmp/libegl1-mesa.deb && /usr/bin/apt-get install /tmp/libgl1-mesa-glx.deb && /usr/bin/apt-get install -y /tmp/Packet_Tracer822_amd64_signed.deb',
  environment => [
    'DEBIAN_FRONTEND=noninteractive',
    'APT_LISTCHANGES_FRONTEND=none',
  ],
  path    => ['/usr/bin', '/bin', '/usr/sbin'],
#  unless  => '/usr/bin/dpkg -s packettracer >/dev/null 2>&1',
  require => [
    Exec['packettracer_eula'],
    Exec['remove_broken_packettracer'],
  ],
}





  exec { 'limpiar_packet':
    command     => '/bin/rm -f /tmp/Packet_Tracer822_amd64_signed.deb /tmp/libegl1-mesa.deb /tmp/libgl1-mesa-glx.deb',
    refreshonly => true,
    subscribe   => Exec['instalar_packet'],
    path        => ['/usr/bin', '/bin'],
  }

}
