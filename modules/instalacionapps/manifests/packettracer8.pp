# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::packettracer8
class instalacionapps::packettracer8 {
	
	$nombreScript = 'C:\\tmp\scriptPacket.ps1'
	$directory_path = 'C:\\Program Files\\Cisco Packet Tracer 8.0'
	$source_file = '\\\10.0.0.21\Instaladores\PacketTracer800_Build212_64bit_setup-signed.exe'
	$destination_file = 'C:\\tmp\\PacketTracer800_Build212_64bit_setup-signed.exe'
	$powershell_path = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'



#script que lleva a cabo la copia y ejecución de la instalación del paquete
	$contenidoScript = "
		if (!(Test-Path -Path \"${directory_path}\")) {
			Copy-Item -Path \"${source_file}\" -Destination \"${destination_file}\"
			Start-Process -FilePath ${destination_file} /verysilent /suppressmsgboxes /norestart -Wait
			Remove-Item -Path \"${destination_file}\"
		}
		Remove-Item -Path \$MyInvocation.MyCommand.Path"


# Crear el archivo de script con el contenido definido
	file { $nombreScript:
		ensure  => 'file',
		content => $contenidoScript,
	}
#Ejecución del script
	exec { 'instalaPacket':
		command => "${powershell_path} -NoProfile -ExecutionPolicy RemoteSigned -File ${nombreScript}",
		require => File[$nombreScript],
		path    => 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0',
	}
}
