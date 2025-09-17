# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::netbeans_windows
class instalacionapps::netbeans_windows {
	$nombreScript = 'C:\\tmp\scriptNetbeans.ps1'
	$directory_path = 'C:\\Program Files\\Netbeans27'
	$source_file = '\\\10.0.0.21\Instaladores\netbeans-27-bin.zip'
	$destination_file = 'C:\\tmp\\netbeans-27-bin.zip'
	$powershell_path = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'
	$path_ejecutable = 'C:\Program Files\\Netbeans27\\netbeans\\bin\\netbeans64.exe'
	$accesodirecto = 'C:\\Users\\Default\\Desktop\\Netbeans 27.lnk'
#script que lleva a cabo la copia y ejecución de la instalación del paquete
	$contenidoScript = "
		if (!(Test-Path -Path \"${directory_path}\")) {
			Copy-Item -Path \"${source_file}\" -Destination \"${destination_file}\"
			Expand-Archive -Path '${destination_file}' -DestinationPath '${directory_path}' -Force
#Start-Process -FilePath ${destination_file} /verysilent /suppressmsgboxes /norestart -Wait
			Remove-Item -Path \"${destination_file}\"
		}
		Remove-Item -Path \$MyInvocation.MyCommand.Path"


# Crear el archivo de script con el contenido definido
	file { $nombreScript:
		ensure  => 'file',
		content => $contenidoScript,
	}
#Ejecución del script
	exec { 'instalaNetbeans':
		command => "${powershell_path} -NoProfile -ExecutionPolicy RemoteSigned -File ${nombreScript}",
		require => File[$nombreScript],
		path    => 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0',
	}
#Creación icono
	exec { 'crear-icono':
		command => "powershell -Command \"\$WshShell = New-Object -ComObject WScript.Shell; \$Shortcut = \$WshShell.CreateShortcut('${accesodirecto}'); \$Shortcut.TargetPath = '${path_ejecutable}'; \$Shortcut.Save()\"",
		creates => $shortcut,
		path => ['C:\Windows\System32\WindowsPowerShell\v1.0', 'C:\Windows\System32'],
#		require => Exec['instalaNetbeans'],
	}
}
