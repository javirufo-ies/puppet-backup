# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include equipos::asir2
class equipos::asir2 {
	if $::kernel == 'windows' {
		Package { provider => chocolatey, }

		include instalacionapps::sqldeveloper
		include instalacionapps::netbeans_windows

#Este paquete ya está en smr2d, que está en el mismo aula
#		package {'vscode':
#			ensure => present,
#		}
		package {'mysql':
			ensure => present,
		}

		package {'mysql.workbench':
			ensure => present,
		}
		
		package {'mariadb':
			ensure => present,
		}

		package {'netbeans':
			ensure => latest,
		}

         }
}
