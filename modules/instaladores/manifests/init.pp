# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instaladores
class instaladores {
	exec { 'repositorioChocolatey':
		command => "choco source add -n=chocolatey -s='http://10.0.0.3:8081/nexus/service/local/nuget/Chocolatey/'",
		path => ["d:\\ProgramData\\chocolatey",	"c:\\ProgramData\\chocolatey"],
	}

	file { 'c:\tmp':
	    ensure => 'directory',
	}
	
}
