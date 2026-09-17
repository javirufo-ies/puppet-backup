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
		ensure   => present,
		password => '',
	}


}





