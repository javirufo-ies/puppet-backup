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


# ============================================================
# Veyon Master global desktop shortcut (Ubuntu + Cinnamon + AD)
# ============================================================

# 1️⃣ Lanzador global (para menú de aplicaciones y referencia común)
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

# 2️⃣ Crear carpeta base en /etc/skel por si está vacía
file { '/etc/skel':
  ensure => directory,
  mode   => '0755',
}

# Crear tanto /etc/skel/Desktop como /etc/skel/Escritorio (por compatibilidad de idioma)
file { ['/etc/skel/Desktop', '/etc/skel/Escritorio']:
  ensure => directory,
  mode   => '0755',
}

# Copiar el lanzador a ambas rutas (para nuevos usuarios locales o AD cacheados)
file { ['/etc/skel/Desktop/veyon-master.desktop', '/etc/skel/Escritorio/veyon-master.desktop']:
  ensure => link,
  target => '/usr/share/applications/veyon-master.desktop',
}

# 3️⃣ Añadir icono a los escritorios de los usuarios ya existentes
exec { 'deploy_veyon_icon_existing_users':
  command => '/bin/bash -c "
    for d in /home/*; do
      conf=$d/.config/user-dirs.dirs;
      if [ -f $conf ]; then
        desktop=$(grep XDG_DESKTOP_DIR $conf | cut -d\\\" -f2 | sed s:\\$HOME:$d:);
      fi;
      [ -z \\\"$desktop\\\" ] && desktop=$d/Desktop;
      [ ! -d \\\"$desktop\\\" ] && desktop=$d/Escritorio;
      if [ -d \\\"$desktop\\\" ]; then
        ln -sf /usr/share/applications/veyon-master.desktop \\\"$desktop/\\\";
        chmod +x \\\"$desktop/veyon-master.desktop\\\";
      fi;
    done"',
  path    => ['/bin', '/usr/bin'],
  onlyif  => '/usr/bin/test -d /home',
}

# 4️⃣ Script de perfil para usuarios nuevos o de dominio (AD)
file { '/etc/profile.d/veyon_icon.sh':
  ensure  => file,
  mode    => '0755',
  content => '#!/bin/bash
ICON="/usr/share/applications/veyon-master.desktop"

# Detectar carpeta de escritorio (independiente del idioma)
if [ -f "$HOME/.config/user-dirs.dirs" ]; then
  DESKTOP_DIR=$(grep XDG_DESKTOP_DIR "$HOME/.config/user-dirs.dirs" | cut -d "\"" -f2 | sed "s:\$HOME:$HOME:")
else
  DESKTOP_DIR="$HOME/Desktop"
  [ ! -d "$DESKTOP_DIR" ] && DESKTOP_DIR="$HOME/Escritorio"
fi

# Crear el icono si no existe
if [ -d "$DESKTOP_DIR" ] && [ ! -e "$DESKTOP_DIR/veyon-master.desktop" ]; then
  ln -sf "$ICON" "$DESKTOP_DIR/"
  chmod +x "$DESKTOP_DIR/veyon-master.desktop"
fi
',
}








}


}
