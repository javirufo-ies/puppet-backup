class dominio::montaje_nas {

  # Paquete necesario para montar recursos SMB/CIFS
  package { 'cifs-utils':
    ensure => installed,
  }

  # Carpeta destino donde se montará el recurso
  file { '/mnt/isos':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Definición del montaje
  mount { '/mnt/isos':
    ensure  => mounted,  # asegura que está montado
    atboot  => true,     # añade entrada a /etc/fstab
    device  => '//10.0.0.33/Repositorio/ISOS',
    fstype  => 'cifs',
    options => 'username=invitado,password=Invit@do2025,ro,iocharset=utf8,file_mode=0444,dir_mode=0555',
    require => [ Package['cifs-utils'], File['/mnt/isos'] ],
  }

 # Copiar el script al cliente
  file { '/etc/profile.d/enlace_nas.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/dominio/enlace_nas.sh',
#    require => Mount['/mnt/isos'],
  }

  # Añadir llamada al script en /etc/profile (opcional, si no quieres confiar en /etc/profile.d/)
  file_line { 'crea_enlace_nas':
    path  => '/etc/profile',
    line  => 'source /etc/profile.d/enlace_nas.sh',
    match => '^source /etc/profile.d/enlace_nas.sh$',
    require => File['/etc/profile.d/enlace_nas.sh'],
  }
}
