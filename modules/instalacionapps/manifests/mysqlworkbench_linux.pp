class instalacionapps::mysqlworkbench_linux {

class instalacionapps::mysqlworkbench_flatpak {

  # Asegurar que Flatpak está instalado
  package { 'flatpak':
    ensure => installed,
  }

  # Agregar el repositorio Flathub si no está
  exec { 'agregar_flathub':
    command => '/usr/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo',
    unless  => '/usr/bin/flatpak remotes | /bin/grep -q flathub',
    require => Package['flatpak'],
  }

  # Instalar MySQL Workbench desde Flathub
  exec { 'instalar_mysqlwb_flatpak':
    command => '/usr/bin/flatpak install -y flathub com.mysql.workbench',
    unless  => '/usr/bin/flatpak list | grep -q com.mysql.workbench',
    require => Exec['agregar_flathub'],
  }
}





}
