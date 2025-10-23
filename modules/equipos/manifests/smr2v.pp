# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include equipos::smr2v
class equipos::smr2v {
	if $::kernel == 'windows' {
		Package { provider => chocolatey, }
		package {'vscode':
			ensure => latest,
		}
		package {'python':
			ensure => present,
		}
		package {'xampp-81':
			ensure => present,
		}
         }
}
