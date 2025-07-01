#Hay que habilitar la ejecución de script en los clientes
class instalacionapps::veyonmaster {

	$nombreScript = 'C:\\tmp\scriptVeyon.ps1'
	$directory_path = 'C:\\Program Files\\Veyon Master'
	$source_file = '\\\10.0.0.21\Instaladores\veyon-4.4.2.0-win64-setup.exe'
	$destination_file = 'C:\\tmp\\veyon-4.4.2.0-win64-setup.exe'
	$powershell_path = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'


#script que lleva a cabo la copia y ejecución de la instalación del paquete
	$contenidoScript = "
		if (!(Test-Path -Path \"${directory_path}\")) {
			Copy-Item -Path \"${source_file}\" -Destination \"${destination_file}\"
			Start-Process -FilePath ${destination_file} /S /ApplyConfig=\\\10.0.0.21\instaladores\veyon.json -Wait
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
