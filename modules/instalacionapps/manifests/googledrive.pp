# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::googledrive
class instalacionapps::googledrive {

  package { ['software-properties-common', 'dirmngr', 'google-drive-ocamlfuse']:
    ensure => installed,
  }

  exec { 'add_ocamlfuse_ppa':
    command => '/usr/bin/add-apt-repository -y ppa:alessandro-strada/ppa',
    unless  => '/usr/bin/grep -h "^deb .\+alessandro-strada/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*',
    require => Package['software-properties-common'],
  }

  exec { 'apt_update_drive':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
    subscribe   => Exec['add_ocamlfuse_ppa'],
  }

}


