# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::avsvideoeditor
class instalacionapps::avsvideoeditor {

	$nombreScript = 'C:\\tmp\scriptAVS.ps1'
	$directory_path = 'C:\\Program Files (x86)\\AVS4YOU'
	$source_file = '\\\10.0.0.21\Instaladores\AVSVideoEditor.exe'
	$destination_file = 'C:\\tmp\\AVSVideoEditor.exe'
	$powershell_path = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'


#script que lleva a cabo la copia y ejecución de la instalación del paquete
	$contenidoScript = "
		if (!(Test-Path -Path \"${directory_path}\")) {
			Copy-Item -Path \"${source_file}\" -Destination \"${destination_file}\"
			Start-Process -FilePath ${destination_file} -ArgumentList \"/SP\",\"/VERYSILENT\",\"/SUPRESSMSGBOXES\" -Wait
			Remove-Item -Path \"${destination_file}\"
		}
		Remove-Item -Path \$MyInvocation.MyCommand.Path"
	


# Crear el archivo de script con el contenido definido
	file { $nombreScript:
		ensure  => 'file',
		content => $contenidoScript,
	}
#Ejecución del script
	exec { 'instalaAVS':
		command => "${powershell_path} -NoProfile -ExecutionPolicy RemoteSigned -File ${nombreScript}",
		require => File[$nombreScript],
		path    => 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0',
	}
}
