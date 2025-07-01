class dominio::ssh 
{

	notify {"SSH":}
	if $facts['os']['family'] == 'windows' {


# 1. Instalar OpenSSH.Server (Windows Capability)
exec { 'Instalar OpenSSH Server':
  command   => 'Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0',
  provider  => powershell,
  unless    => 'if ((Get-WindowsCapability -Online | Where-Object { $_.Name -eq "OpenSSH.Server~~~~0.0.1.0" }).State -eq "Installed") { exit 0 } else { exit 1 }',
  logoutput => true,
}

notify { 'SSH Server instalado': 
  require => Exec['Instalar OpenSSH Server'],
}

# 2. Habilitar e iniciar el servicio sshd
service { 'sshd':
  ensure    => running,
  enable    => true,
  provider  => windows,
  require   => Exec['Instalar OpenSSH Server'],
}

# 3. (Opcional) Asegurar que el puerto 22 esté abierto en el firewall
exec { 'Abrir puerto SSH en el firewall':
  command  => 'New-NetFirewallRule -Name "SSH" -DisplayName "SSH" -Protocol TCP -LocalPort 22 -Action Allow -Direction Inbound',
  provider => powershell,
  # corregir el unless para que sea un comando que devuelva 0/1 adecuadamente
  unless   => 'if (Get-NetFirewallRule -Name "SSH" -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }',
  require  => Service['sshd'],  # mejor que requiera el servicio, para que esté activo al abrir el puerto
}



}
else {



	package {'openssh-server':
		ensure => latest,
	}

	file { '/etc/ssh/sshd_config':
	  ensure  => file,
	  owner   => 'root',
	  group   => 'root',
	  mode    => '0600',
	  content => template('dominio/sshd_config.erb'),
	  notify  => Service['ssh'],
	}


	service { 'ssh':
		ensure    => running,
		enable    => true,
		hasstatus => true,
		hasrestart => true,
		require  => Package['openssh-server'],
	}
	
}




}
