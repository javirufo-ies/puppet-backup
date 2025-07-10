# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::packettracer_linux
class instalacionapps::packettracer_linux {

package {['gdebi', 'libgl1-mesa-dri','libgl1','sudo','dialog','xdg-utils','gtk-update-icon-cache','libglx-mesa0','libpulse0','libnss3','libxss1','libasound2t64','libxslt1.1','libxkbcommon-x11-0','libxcb-xinerama0-dev','libfreetype6','libc6','libstdc++6']:
	ensure => installed,
	}

exec { 'copiar_packet':
	command => "smbclient //10.0.0.21/Repositorio -N -c 'cd Instaladores; get Packet_Tracer822_amd64_signed.deb /tmp/packet.deb; get libegl1-mesa_23.0.4-0ubuntu1.22.04.1_amd64.deb /tmp/libegl1-mesa_23.0.4-0ubuntu1.22.04.1_amd64.deb; get libgl1-mesa-glx_23.0.4-0ubuntu1.22.04.1_amd64.deb /tmp/libgl1-mesa-glx_23.0.4-0ubuntu1.22.04.1_amd64.deb'",
	creates => '/tmp/packet.deb',
	path =>	['/usr/bin', '/bin'],
}



exec { 'instalar_packet':
  command => 'echo s | gdebi /tmp/libegl1-mesa_23.0.4-0ubuntu1.22.04.1_amd64.deb /tmp/libgl1-mesa-glx_23.0.4-0ubuntu1.22.04.1_amd64.deb && gdebi /tmp/packet.deb && rm /tmp/*.deb ',
  environment => ['DEBIAN_FRONTEND=noninteractive'],
  path    => ['/usr/bin', '/bin' , '/usr/sbin'],
#  unless  => '/usr/bin/dpkg -l | grep -qw packettracer',
  require => Exec['copiar_packet'],
}


}
