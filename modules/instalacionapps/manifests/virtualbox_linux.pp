class instalacionapps::virtualbox_linux {
#hay que eliminar KVM para poder usar virtualbox
  # Paquetes KVM que queremos eliminar
  $kvm_paquetes = [
    'qemu-kvm',
    'libvirt-daemon-system',
    'libvirt-clients',
  ]

  package { $kvm_paquetes:
    ensure => absent,
  }

  # Detener y deshabilitar el servicio libvirtd
  service { 'libvirtd':
    ensure => 'stopped',
    enable => false,
  }

  # Eliminar módulos del kernel KVM si están cargados
  exec { 'eliminar_modulos_kvm':
    command => '/sbin/rmmod kvm_intel kvm_amd kvm || true',
    path    => ['/sbin','/bin','/usr/sbin','/usr/bin'],
    onlyif  => 'lsmod | grep -E "kvm(_intel|_amd)?"',
    require => Package[$kvm_paquetes],
  }





  # Añadir la clave pública de Oracle para VirtualBox → usando keyring
  exec { 'add_virtualbox_key':
    command => 'wget -qO- https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor | tee /etc/apt/keyrings/oracle-virtualbox.gpg > /dev/null',
    creates => '/etc/apt/keyrings/oracle-virtualbox.gpg',
    path    => ['/usr/bin', '/bin'],
  }

  # Configurar el repositorio oficial de VirtualBox (Ubuntu/Debian)
  exec { 'add_virtualbox_repo':
    command => 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/oracle-virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian noble contrib" > /etc/apt/sources.list.d/virtualbox.list && apt-get update',
    unless  => 'test -f /etc/apt/sources.list.d/virtualbox.list',
    require => Exec['add_virtualbox_key'],
    path    => ['/usr/bin', '/bin'],
  }

  # Instalación de VirtualBox
  package { 'virtualbox-7.2':
    ensure  => latest,
    require => Exec['add_virtualbox_repo'],
  }







# Usamos un script rápido en una sola línea que:
  # 1. Mira qué versión real de VBoxManage hay instalada (ej: 7.0.26)
  # 2. Si no coincide con el extpack actual, borra el temporal viejo, descarga el suyo y lo instala aceptando la licencia.


file { '/usr/local/bin/install_virtualbox_extpack.sh':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
  source  => 'puppet:///modules/instalacionapps/install_virtualbox_extpack.sh',
  require => Package['virtualbox-7.2'],
}

exec { 'instalar_extension_pack_sincronizado':
  user    => 'root',
  path    => ['/usr/bin', '/bin', '/usr/sbin', '/sbin'],
  command => '/usr/local/bin/install_virtualbox_extpack.sh',
	logoutput => true,
  require => [
    Package['virtualbox-7.2'],
    File['/usr/local/bin/install_virtualbox_extpack.sh'],
  ],
}

# Crear archivo de blacklist solo si no existe
file { '/etc/modprobe.d/blacklist-kvm-intel.conf':
  ensure  => file,
  content => "blacklist kvm_intel\n",
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}

# Quitar el módulo si el archivo se creó (solo una vez)
exec { 'remove-kvm-intel':
  command     => '/sbin/modprobe -r kvm_intel',
  path        => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  refreshonly => true,
  subscribe   => File['/etc/modprobe.d/blacklist-kvm-intel.conf'],
}





}
