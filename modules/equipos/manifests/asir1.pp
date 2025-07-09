# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include equipos::asir1
class equipos::asir1 {
	if $::kernel == 'windows' {
		Package { provider => chocolatey, }

	} else {
		include instalacionapps::packettracer_linux
		include instalacionapps::vscode_linux
		package {'python3':
			ensure => installed,
		}
                package {'default-mysql-server':
                        ensure => installed,
                }

         }
}
