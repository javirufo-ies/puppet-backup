# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::packettracer_linux
class instalacionapps::packettracer_linux {

package {['sudo','dialog','xdg-utils','gtk-update-icon-cache','libgl1-mesa-glx','libpulse0','libnss3','libxss1','libasound2','libxslt1.1','libxkbcommon-x11-0','libxcb-xinerama0-dev','libfreetype6','libc6','libstdc++6']:
	ensure => installed,
	}

exec { 'copiar_packet':
	command => "smbclient //10.0.0.21/Repositorio -N -c 'cd Instaladores; get Packet_Tracer822_amd64_signed.deb /tmp/packet.deb'",
	creates => '/tmp/packet.deb',
	path =>	['/usr/bin', '/bin'],
}


exec { 'instalar_packet':
  command => 'dpkg -i /tmp/packet.deb && rm /tmp/packet.deb',
environment => ['DEBIAN_FRONTEND=noninteractive'],
  path    => ['/bin', '/usr/bin', '/usr/local/sbin', '/usr/local/bin', '/sbin', '/usr/sbin'],
  require => Exec['copiar_packet'],
}


}
