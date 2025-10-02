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
    options => 'username=guest,password=,ro,iocharset=utf8,file_mode=0444,dir_mode=0555',
    require => [ Package['cifs-utils'], File['/mnt/isos'] ],
  }
}
