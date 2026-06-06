# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include equipos::smr1d
class equipos::smr1d {
	include instalacionapps::packettracer_linux

	package {'hashcat':	
		ensure => present,
	}
}
