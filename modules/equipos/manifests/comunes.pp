# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include equipos::comunes
class equipos::comunes {
if $::kernel == 'windows' {
	notify{'PUPPET SOBRE WINDOWS': }
        include chocolatey
        chocolateysource { 'chocolateylocal1':
                ensure => present,
                location => 'http://10.0.0.3:8081/repository/Chocolatey-proxy/',
        }
#        chocolateysource { 'chocolatey':
#                ensure => disabled,
#        }

        Package { provider => chocolatey,}

	include dominio::ssh
	include dominio::unirdominio

        


	file { 'c:/ProgramData/PuppetLabs/puppet/etc/puppet.conf':
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
		ensure => present,
		install_options => ['--params', '"','/ExtensionPack','"'],
	}

	include instalacionapps::vmwareworkstation
#        include instalacionapps::sqldeveloper


        package {'googlechrome':
                ensure => latest,
                 install_options => [
                     '--ignore-checksums',
                 ],
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
		install_options => [
		    '--ignore-checksums',
		],
        }


        package {'winrar':
                ensure => present,
        }


	package {'mobaxterm':
		ensure => present,
	}

	package {'winscp':
		ensure => present,
	}

	package {'notepadplusplus':
		ensure => present,
	}


	package {'gimp':
		ensure => present,
	}

	package {'openjdk':
		ensure => latest,
	}

#	package {'winget':
#		ensure => present,
#	}
} 
#EQUIPOS LINUX
else{
	notify {'PUPPET SOBRE LINUX':}
	file { '/etc/puppet/puppet.conf':
		ensure => file,
                source => 'puppet:///modules/equipos/puppet.conf',
                replace => true,
        }
	package {'nfs-common':
		ensure => latest,
	}
	package {'smbclient':
		ensure => latest,
	}

	package {'wget':
		ensure => latest,
	}

	package {'gpg':
		ensure => latest,
	}
	package {'lsb-release':
		ensure => installed,
	}
	

	include dominio::fondo_linux
	include dominio::nombre
	include dominio::ssh
	include dominio::unirdominio
	include dominio::montaje_nas
	include instalacionapps::virtualbox_linux
	include instalacionapps::chrome_linux
	include instalacionapps::vmware_linux
	include instalacionapps::mysqlworkbench_linux
	package {'filezilla':
		ensure => installed,
	}
	

	package {'rclone':
		ensure => installed,
	}

	package { 'rclone-browser':
		ensure => installed,
	}

# VEYON
	package { 'veyon-service':
		ensure => installed,
	}

#	file { '/etc/veyon/public.key':
#		ensure => file,
#		source => 'puppet:///modules/equipos/public.key',  # O una ruta local/nfs
#		owner  => 'root',
#		group  => 'root',
#		mode   => '0644',
#	}
#
#	exec { 'Importar clave pública Veyon':
#		command => '/usr/bin/veyon-cli authkeys import public adminveyon /etc/veyon/public.key',
#		unless  => '/usr/bin/veyon-cli authkeys list | grep adminveyon',
#		require => [Package['veyon-service'], File['/etc/veyon/public.key']],
#	}
#
#	exec { 'Configurar autenticación por clave':
#		command => '/usr/bin/veyon-cli config set AuthenticationMethod PublicKey',
#		unless  => '/usr/bin/veyon-cli config get AuthenticationMethod | grep PublicKey',
#		require => Exec['Importar clave pública Veyon'],
#	}

	service { 'veyon':
		ensure => running,
		enable => true,
		require => Package['veyon-service'],
	}





}

}
