# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
class instalacionapps::vmwareworkstation {
	
	$nombreScript = 'C:\\tmp\scriptVMWare.ps1'
	$directory_path = 'C:\\Program Files (x86)\\VMware'
	$source_file = '\\\10.0.0.21\Instaladores\VMware-workstation-full-17.5.2-23775571.exe'
	$destination_file = 'C:\\tmp\\VMware-workstation-full-17.5.2-23775571.exe'
	$powershell_path = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'



#script que lleva a cabo la copia y ejecución de la instalación del paquete
	$contenidoScript = "
		if (!(Test-Path -Path \"${directory_path}\")) {
			Copy-Item -Path \"${source_file}\" -Destination \"${destination_file}\"
			Start-Process -FilePath ${destination_file} -ArgumentList \"/s /v`\"/qn EULAS_AGREED=1 AUTOSOFTWAREUPDATE=1`\"\" -Wait
			Remove-Item -Path \"${destination_file}\"
		}
		Remove-Item -Path \$MyInvocation.MyCommand.Path"


# Crear el archivo de script con el contenido definido
	file { $nombreScript:
		ensure  => 'file',
		content => $contenidoScript,
	}
#Ejecución del script
	exec { 'instalaVMWare':
		command => "${powershell_path} -NoProfile -ExecutionPolicy RemoteSigned -File ${nombreScript}",
		require => File[$nombreScript],
		path    => 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0',
	}
}
