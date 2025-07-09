# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::mysqlworkbench_linux
class instalacionapps::mysqlworkbench_linux {


  # Descargar el paquete del repositorio oficial de MySQL
  exec { 'descargar_mysql_apt_config':
    command => '/usr/bin/wget -O /tmp/mysql-apt-config.deb https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb',
    creates => '/tmp/mysql-apt-config.deb',
    require => Package['wget'],
  }

  # Instalar el repositorio .deb (modo no interactivo con debconf)
  exec { 'instalar_mysql_apt_config':
    command => 'DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/mysql-apt-config.deb',
    unless  => '/usr/bin/test -f /etc/apt/sources.list.d/mysql.list',
    require => Exec['descargar_mysql_apt_config'],
  }

  # Actualizar APT tras añadir el repositorio
  exec { 'apt_update_mysql_repo':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
    subscribe   => Exec['instalar_mysql_apt_config'],
  }

  # Instalar MySQL Workbench
  package { 'mysql-workbench-community':
    ensure  => installed,
    require => Exec['apt_update_mysql_repo'],
  }
}

