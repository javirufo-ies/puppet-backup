#Hay que habilitar la ejecución de script en los clientes
class instalacionapps::veyonmaster {
if $::kernel == 'windows' {
	$nombreScript = 'C:\\tmp\scriptVeyon.ps1'
	$directory_path = 'C:\\Program Files\\Veyon'
	$source_file = '\\\10.0.0.21\Instaladores\veyon-4.4.2.0-win64-setup.exe'
	$destination_file = 'C:\\tmp\\veyon-4.4.2.0-win64-setup.exe'
	$powershell_path = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'


#script que lleva a cabo la copia y ejecución de la instalación del paquete
	$contenidoScript = "
		if (!(Test-Path -Path \"${directory_path}\")) {
			Copy-Item -Path \"${source_file}\" -Destination \"${destination_file}\"
			Start-Process -FilePath ${destination_file} -ArgumentList \"/S /ApplyConfig=\\\10.0.0.21\Instaladores\veyon.json\" -Wait
		Remove-Item -Path \"${destination_file}\"
		}
		Remove-Item -Path \$MyInvocation.MyCommand.Path"


# Crear el archivo de script con el contenido definido
	file { $nombreScript:
		ensure  => 'file',
		content => $contenidoScript,
	}
#Ejecución del script
	exec { 'instalaVeyon':
		command => "${powershell_path} -NoProfile -ExecutionPolicy RemoteSigned -File ${nombreScript}",
		require => File[$nombreScript],
		path    => 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0',
	}
}

#Cliente LINUX
else {

# Aseguramos dependencias
      package { ['wget','gnupg2']:
        ensure => installed,
      }

      # Añadimos repositorio oficial de Veyon
      exec { 'add_veyon_repo':
        command => '/usr/bin/wget -O - https://veyon.io/key/veyon.gpg | apt-key add - && echo "deb http://ppa.launchpad.net/veyon/stable/ubuntu focal main" > /etc/apt/sources.list.d/veyon.list && apt-get update',
        creates => '/etc/apt/sources.list.d/veyon.list',
      }

      # Instalamos el paquete Veyon Master
      package { 'veyon':
        ensure  => installed,
        require => Exec['add_veyon_repo'],
      }
    

# Copiar la configuración (JSON)
	file { '/etc/veyon/veyon.json':
    		ensure  => file,
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		source  => 'puppet:///modules/instalacionapps/veyon.json',
		require => Package['veyon'],
		notify  => Service['veyon-service'], # Reinicia servicio si cambia
  }
}


}
