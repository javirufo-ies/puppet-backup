# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include equipos::asir1
class equipos::asir1 {
	if $::kernel == 'windows' {
		Package { provider => chocolatey, }
		package {'vscode':
			ensure => present,
		}
		package {'xampp-81':
			ensure => present,
		}
         }
}
