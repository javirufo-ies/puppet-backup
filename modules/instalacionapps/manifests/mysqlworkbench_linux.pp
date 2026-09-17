class instalacionapps::mysqlworkbench_linux {


  # ============================
  # MYSQL WORKBENCH
  # ============================

  package { 'mysql-workbench':
    ensure  => installed,
    require => Class['mysqlworkbench_linux::server'],
  }


	#Quitar clave root
mysql_user { 'root@localhost':
  ensure        => present,
  plugin        => 'mysql_native_password',
  password_hash => mysql_password('12345678'),
}

}





