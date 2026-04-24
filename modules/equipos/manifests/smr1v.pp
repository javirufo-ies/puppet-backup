# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include equipos::smr1v
class equipos::smr1v {
	if $::kernel == 'windows' {
		Package { provider => chocolatey, }

	} else {
		include instalacionapps::packettracer_linux
	        package { 'openshot-qt':
			ensure => present,
	        }	

         }
}
