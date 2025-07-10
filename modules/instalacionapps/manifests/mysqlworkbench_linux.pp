# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::mysqlworkbench_linux
class instalacionapps::mysqlworkbench_linux {


exec { 'copiar_mysqlwb':
	command => "smbclient //10.0.0.21/Repositorio -N -c 'cd Instaladores; get mysql-workbench-community_8.0.42-1ubuntu24.10_amd64.deb /tmp/mysqlwb.deb'",
	creates => '/tmp/mysqlwb.deb',
	path =>	['/usr/bin', '/bin'],
}


exec { 'instalar_mysqlwb':
  command => 'sh /tmp/mysqlwb.deb && rm /tmp/mysqlwb.deb',
  path    => ['/bin', '/usr/bin'],
  require => Exec['copiar_mysqlwb'],
}





}
