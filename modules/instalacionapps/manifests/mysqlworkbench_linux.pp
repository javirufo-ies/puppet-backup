class instalacionapps::mysqlworkbench_linux {


mysql_user { 'alumno@localhost':
  ensure        => present,
  password_hash => mysql::password('12345678'),
}

mysql_grant { 'alumno@localhost/*.*':
  ensure     => present,
  privileges => ['ALL'],
  table      => '*.*',
  user       => 'alumno@localhost',
}

}





