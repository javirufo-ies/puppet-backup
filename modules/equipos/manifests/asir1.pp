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
		package {'vscode':
			ensure => present,
		}

		package {'python':
			ensure => present,
		}
                package {'mysql':
                        ensure => present,
                }
                package {'mysql.workbench':
                        ensure => present,
                }		

         }
}
