# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::basex
class instalacionapps::basex {
	$nombreScript = 'C:\\tmp\baseX.ps1'
	$directory_path = 'C:\\Program Files\\BaseX'
	$source_file = '\\\10.0.0.21\Instaladores\BaseX110.exe'
	$destination_file = 'C:\\tmp\\BaseX110.exe'
	$powershell_path = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'

#script que lleva a cabo la copia y ejecución de la instalación del paquete
	$contenidoScript = "
		if (!(Test-Path -Path \"${directory_path}\")) {
			Copy-Item -Path \"${source_file}\" -Destination \"${destination_file}\"
			Start-Process -FilePath ${destination_file} /S -Wait
			Remove-Item -Path \"${destination_file}\"
		}
		Remove-Item -Path \$MyInvocation.MyCommand.Path"


# Crear el archivo de script con el contenido definido
	file { $nombreScript:
		ensure  => 'file',
		content => $contenidoScript,
	}
#Ejecución del script
	exec { 'instalaBaseX':
		command => "${powershell_path} -NoProfile -ExecutionPolicy RemoteSigned -File ${nombreScript}",
		require => File[$nombreScript],
		path    => 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0',
	}
}
