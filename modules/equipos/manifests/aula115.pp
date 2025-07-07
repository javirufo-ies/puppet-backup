# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include equipos::aula115
class equipos::aula115 {
        include instaladores
	include chocolatey
        if $::kernel == 'windows' {
                PAckage { provider => chocolatey,}
        

        package { '7zip':
                ensure => present,
        }
        package { 'jdk8':
                ensure => present,
        }
        package { 'gimp':
                ensure => present,
        }
        package { 'office365business':
                ensure => present,
        }
	package {'openshot':
		ensure => present,
	}
        exec {'PacketTracer8':
                command => 'T:/PacketTracer80.bat',
                provider => windows,
        }
	} else {
		include instalacionapps::packettracer_linux
	}
}
