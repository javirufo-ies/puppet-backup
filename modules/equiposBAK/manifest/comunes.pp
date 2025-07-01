# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include equipos::comunes
class equipos::comunes {
        include chocolatey
        chocolateysource { 'chocolateylocal1':
                ensure => present,
                location => 'http://10.0.0.3:8081/repository/Chocolatey-proxy/',
        }
        chocolateysource { 'chocolatey':
                ensure => disabled,
        }
        if $::kernel == 'windows' {
                PAckage { provider => chocolatey,}
        }


	file { 'c://ProgramData/\PuppetLabs/puppet/etc/puppet.conf':
		ensure => file,
		source => 'puppet:///modules/equipos/puppet.conf',
		replace => true,
	}
	
	package { 'veyon':
               ensure => present,
	}
        service { 'VeyonService':
            ensure  => running,
            enable  => true,
            require => Package['veyon'],
        }

	package {'miktex':
		ensure => present,
	}
	package {'KB2919442':
		ensure => present,
	}

        package { 'libreoffice-fresh':
                ensure => present,
        }
        package { 'firefox':
                ensure => latest,
        }

	package {'virtualbox':
		ensure => latest,
		install_options => ['--params', '"','/ExtensionPack','"'],
	}

#	include instalacionapps::vmwareworkstation
        include instalacionapps::sqldeveloper


        package {'googlechrome':
                ensure => present,
        }
        package {'adobereader':
                ensure => present,
        }
        package {'googledrive':
                ensure => present,
        }
        package {'psexec':
                ensure => present,
        }
        package {'pstools':
                ensure => present,
        }
        package {'sysinternals':
                ensure => present,
        }
        package {'winrar':
                ensure => present,
        }
}

