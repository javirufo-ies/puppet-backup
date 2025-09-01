# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include equipos::aula114
class equipos::aula114 {
        include instaladores
	include chocolatey
        if $::kernel == 'windows' {
                PAckage { provider => chocolatey,}
        }
        package { 'putty':
                ensure => latest,
        }
        package { 'winscp':
                ensure => present,
        }
        package { '7zip':
                ensure => present,
        }
        package { 'notepadplusplus':
                ensure => present,
        }
        package { 'vscode':
                ensure => present,
        }
        package { 'jdk8':
                ensure => present,
        }
#        package { 'mysql.workbench':
#                ensure => present,
#        }
        package { 'mysql':
                ensure => present,
                  install_options => [
                      '--ignore-checksums',
                 ],
        }

	package {'mariadb':
		ensure => present,
	}
#        package { 'oracle-sql-developer':
#               ensure => present,
#      }
        package { 'xampp-81':
                ensure => present,
        }

	package {'wireshark':
		ensure => present,
	}

        exec {'OracleDeveloper':
                command => 'T:/oracle.bat',
                provider => windows,
        }

        exec {'PacketTracer8':
                command => 'T:/PacketTracer80.bat',
                provider => windows,
        }

	exec {'MysqlWorkbench':
		command => 'T:/mysqlworkbench.bat',
		provider => windows,
	}
	
}
