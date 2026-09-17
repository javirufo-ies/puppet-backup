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
  password_hash => mysql::password('12345678'),
}

mysql_user { 'root@127.0.0.1':
  ensure        => present,
  password_hash => mysql::password('12345678'),
}


}





