# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::sqldeveloper
class instalacionapps::sqldeveloper {
	$nombreScript = 'c:\\tmp\scriptSQLDeveloper.ps1'
#	$directory_path = 'C:\\Program Files\\SQLDeveloper'
	$directory_path = 'C:\\PRogram Files'
	$source_file = '\\\10.0.0.21\Instaladores\sqldeveloper-23.1.1.345.2114-x64.zip'
	$destination_file = 'C:\\tmp\\sqldeveloper-23.1.1.345.2114-x64.zip'
	$powershell_path = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'


#script que lleva a cabo la copia y ejecución de la instalación del paquete
	$contenidoScript = "
		if (!(Test-Path -Path \"${directory_path}\")) {
			Copy-Item -Path \"${source_file}\" -Destination \"${destination_file}\"
			Expand-Archive \"$destination_file\" -DestinationPath \"${directory_path}\"
			Remove-Item -Path \"${destination_file}\"
		}
#		Remove-Item -Path \$MyInvocation.MyCommand.Path"


# Crear el archivo de script con el contenido definido
	file { $nombreScript:
		ensure  => 'file',
		content => $contenidoScript,
	}
#Ejecución del script
	exec { 'instalaSQLdeveloper':
		command => "${powershell_path} -NoProfile -ExecutionPolicy RemoteSigned -File ${nombreScript}",
		require => File[$nombreScript],
		path    => 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0',
	}
}
