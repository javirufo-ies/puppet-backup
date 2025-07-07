# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::packettracer_linux
class instalacionapps::packettracer_linux {




exec { 'copiar_packet':
  command => "smbclient //10.0.0.21/Repositorio -N -c 'cd Instaladores; get Packet_Tracer822_amd64_signed.deb /tmp/packettracer.deb'",
  creates => '/tmp/packet.deb',
	path =>	['/usr/bin', '/bin'],
  require => Mount['/tmp/nas_instaladores'],
}

exec { 'instalar_packet':
  command => 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin dpkg -i /tmp/packet.deb && rm /tmp/packet.deb',
  path    => ['/bin', '/usr/bin'],
  require => Exec['copiar_packet'],
}




}
