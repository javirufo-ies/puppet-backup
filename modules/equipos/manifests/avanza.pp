# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include equipos::avanza
class equipos::avanza {
	if $::kernel == 'windows' {
		Package { provider => chocolatey, }
		package {'blender':
			ensure => present,
		}
		package {'safeexambrowser':
			ensure => present,
		}
	} else {

# Definimos rutas para mantener el código limpio
		$ruta_ova     = '/var/tmp/kali.ova'
		$usuario_vm   = 'examen'
		$grupo_vm     = 'usuarios del dominio'
		$nombre_vm    = 'Kali 2026'

# 1. Copiar el archivo OVA desde el servidor Puppet al cliente
		file { $ruta_ova:
			ensure => present,
			source => "puppet:///modules/equipos/kali.ova",
			owner  => $usuario_vm,
			group  => $grupo_vm,
			mode   => '0644',
# Evita que Puppet re-transmita el archivo si solo cambia la fecha de modificación
			checksum => 'md5', 
		  }





# A. Enviamos el script de limpieza al cliente de forma segura
  file { '/usr/local/bin/limpiar_vbox.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/equipos/limpiar_vbox.sh',
  }




# Ejecutamos el script maestro que limpia y luego importa ordenadamente
exec { 'gestion_maquina_examen_vbox':
    user        => 'root',
    command     => '/usr/local/bin/limpiar_vbox_examen.sh',    
    # Se ejecuta a menos que exista la carpeta limpia Y NO exista ningún clon (" 1")
    unless      => "/usr/bin/test -d \"/home/${usuario_vm}/VirtualBox VMs/kali-linux-2026.1-virtualbox-amd64\" && /usr/bin/test ! -d \"/home/${usuario_vm}/VirtualBox VMs/kali-linux-2026.1-virtualbox-amd64 1\"",    
    timeout     => 2400,
    logoutput   => true,
    require     => [ File['/var/tmp/kali.ova'], File['/usr/local/bin/limpiar_vbox.sh'] ],
  }



# C. La importación controlada, blindada y sin WARNINGS
  exec { 'importar_vbox_examen':
    user        => 'root', # Ejecutamos como root para controlar el entorno con sudo
    # Usamos sudo -H e inyectamos USER y LOGNAME para que VirtualBox no se queje
    command     => "/usr/bin/sudo -H -u ${usuario_vm} USER=${usuario_vm} LOGNAME=${usuario_vm} /usr/bin/VBoxManage import ${ruta_ova} --vsys 0 --vmname ${nombre_vm} --eula accept",
    # Condición de parada: Si la carpeta con la nueva versión existe, pasa de largo
    unless      => "/usr/bin/test -d \"/home/${usuario_vm}/VirtualBox VMs/${nombre_vm}\"",
    
    timeout     => 1200,
    logoutput   => on_failure,
    require     => [ File[$ruta_ova], Exec['gestion_maquina_examen_vbox'] ],
  }





		file { '/etc/modprobe.d/blacklist-kvm.conf':
			ensure  => present,
			owner   => 'root',
			group   => 'root',
			mode    => '0644',
			content => "# Deshabilitado por Puppet para permitir el uso de VirtualBox\nblacklist kvm\nblacklist kvm_amd\n",
		}

# 2. Descargar el módulo kvm_amd inmediatamente de la memoria (si está cargado)
		exec { 'descargar_kvm_amd':
			command => '/usr/sbin/rmmod kvm_amd',
			onlyif  => '/usr/bin/lsmod | /usr/bin/grep -q "^kvm_amd"',
			require => File['/etc/modprobe.d/blacklist-kvm.conf'],
# Si hay máquinas de KVM corriendo, rmmod fallará. Ponemos esto antes de importar la VM.
			before  => Exec['importar_vbox_examen'], 
		}

# 3. Descargar el módulo genérico kvm inmediatamente de la memoria
		exec { 'descargar_kvm':
			command => '/usr/sbin/rmmod kvm',
			onlyif  => '/usr/bin/lsmod | /usr/bin/grep -q "^kvm "',
			require => Exec['descargar_kvm_amd'],
			before  => Exec['importar_vbox_examen'],
		}



# Cierre del else        
	}
# Cierre de la clase
}
