# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::veyon_cliente_linux
class instalacionapps::veyon_cliente_linux {
  package { 'veyon':
    ensure => installed,
  }

  file { '/etc/veyon/keys/public/admin':
    ensure  => file,
    source  => 'puppet:///instalacionapps/veyon_clave_publica',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/veyon/veyon.conf':
    ensure  => file,
    source  => 'puppet:///instalacionapps/veyon.json',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  service { 'veyon-service':
    ensure     => running,
    enable     => true,
    hasrestart => true,
  }
}

