class instalacionapps::mysqlworkbench_linux {

class instalacionapps::mysqlworkbench_flatpak {

  # Instalar MySQL Workbench desde Flathub
  exec { 'instalar_mysqlwb':
    command => 'snap install mysql-workbench-community',
  }
}





}
