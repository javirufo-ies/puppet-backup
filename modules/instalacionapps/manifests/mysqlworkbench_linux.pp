class instalacionapps::mysqlworkbench_linux {


  exec { 'crear_usuario_alumno_mysql':
    command => "/usr/bin/mysql -e \"CREATE USER IF NOT EXISTS 'alumno'@'localhost' IDENTIFIED BY '12345678';\"",
    unless  => "/usr/bin/mysql -NBe \"SELECT User FROM mysql.user WHERE User='alumno' AND Host='localhost'\" | /bin/grep -q '^alumno\$'",
    path    => ['/usr/bin', '/bin'],
  }

  exec { 'permisos_usuario_alumno_mysql':
    command => "/usr/bin/mysql -e \"GRANT ALL PRIVILEGES ON *.* TO 'alumno'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;\"",
    path    => ['/usr/bin', '/bin'],
    require => Exec['crear_usuario_alumno_mysql'],
  }


exec { 'instalar_mysql_workbench':
  command => '/usr/bin/snap install mysql-workbench-community',
  unless  => '/usr/bin/snap list mysql-workbench-community',
  require => Package['snapd'],
  path    => ['/usr/bin','/bin'],
}

exec { 'mysql_workbench_password_manager':
  command => '/usr/bin/snap connect mysql-workbench-community:password-manager-service',
  unless  => '/usr/bin/snap connections mysql-workbench-community | grep password-manager-service | grep -q :password-manager-service',
  require => Exec['instalar_mysql_workbench'],
  path    => ['/usr/bin','/bin'],
}

}





