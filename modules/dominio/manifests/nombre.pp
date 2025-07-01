# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dominio::nombre
class dominio::nombre {
# Variables (ajusta el dominio según tu entorno)
$domain = 'ciclos.valledeljerte3'

# Obtener el hostname corto actual
$hostname_short = $facts['networking']['hostname']

# Construir FQDN
$fqdn = "${hostname_short}.${domain}"

# 1. Establecer hostname corto (opcional si ya está bien)
exec { 'set_hostname':
  command => "/bin/hostnamectl set-hostname ${fqdn}",
  unless  => "/bin/hostnamectl status | grep 'Static hostname: ${hostname_short}'",
  path    => ['/bin','/usr/bin'],
}

# 2. Configurar /etc/hosts para incluir el FQDN y hostname corto
file_line { 'hosts_fqdn_entry':
  path  => '/etc/hosts',
  line  => "127.0.1.1 ${fqdn} ${hostname_short}",
  match => '^127\.0\.1\.1',
  notify => Exec['restart_puppet_agent'],
}

# 3. Configurar certname en puppet.conf
#ini_setting { 'puppet_certname':
#  ensure  => present,
#  path    => '/etc/puppetlabs/puppet/puppet.conf',
#  section => 'main',
#  setting => 'certname',
#  value   => $fqdn,
#  notify  => Exec['restart_puppet_agent'],
#}

# 4. Reiniciar agente puppet para que coja el nuevo certname (opcional)
exec { 'restart_puppet_agent':
  command     => '/bin/systemctl restart puppet',
  refreshonly => true,
  path        => ['/bin','/usr/bin','/sbin','/usr/sbin'],
}

}
