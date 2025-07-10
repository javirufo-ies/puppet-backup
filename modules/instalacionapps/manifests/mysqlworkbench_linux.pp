class instalacionapps::mysqlworkbench_linux {


  # Instalar MySQL Workbench desde Flathub
  exec { 'instalar_mysqlwb':
    command => 'snap install mysql-workbench-community',
  }
}





