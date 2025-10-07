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
      package { ['gnupg2', 'veyon-master']:
        ensure => installed,
      }


# Copiar la configuración (JSON)
	file { '/etc/veyon/veyon.json':
    		ensure  => file,
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		source  => 'puppet:///modules/instalacionapps/veyon.json',
#		require => Package['veyon'],
		notify => Service['veyon'],
	}
# Manifiesto Puppet para desplegar acceso directo global de Veyon Master (Ubuntu + Cinnamon)
file { '/usr/share/applications/veyon-master.desktop':
  ensure  => file,
  mode    => '0755',
  content => "[Desktop Entry]
Type=Application
Name=Veyon Master
Exec=/usr/bin/veyon-master
Icon=veyon
Terminal=false
Categories=Education;Utility;
Comment=Lanzar Veyon Master
",
}

# Copiar el icono a /etc/skel (para nuevos usuarios locales o AD cacheados)
file { '/etc/skel/Escritorio/veyon-master.desktop':
  ensure => link,
  target => '/usr/share/applications/veyon-master.desktop',
}

# Crear enlace para todos los usuarios existentes locales
exec { 'deploy_veyon_icon_existing_users':
  command => '/bin/bash -c "for d in /home/*/Escritorio; do ln -sf /usr/share/applications/veyon-master.desktop $d/; chmod +x $d/veyon-master.desktop; done"',
  path    => ['/bin', '/usr/bin'],
  onlyif  => '/usr/bin/test -d /home',
}

# Crear script que añade el icono cuando un usuario de AD inicia sesión (si su carpeta home aún no existía)
file { '/etc/profile.d/veyon_icon.sh':
  ensure  => file,
  mode    => '0755',
  content => '#!/bin/bash
DESKTOP_DIR="$HOME/Escritorio"
ICON="/usr/share/applications/veyon-master.desktop"
if [ -d "$DESKTOP_DIR" ] && [ ! -e "$DESKTOP_DIR/veyon-master.desktop" ]; then
  ln -sf "$ICON" "$DESKTOP_DIR/"
  chmod +x "$DESKTOP_DIR/veyon-master.desktop"
fi
',
}








}


}
