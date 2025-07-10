class instalacionapps::mysqlworkbench_linux {


  # Instalar MySQL Workbench desde Flathub
  exec { 'instalar_mysqlwb':
    command => '/usr/bin/snap install mysql-workbench-community',
  }
}





