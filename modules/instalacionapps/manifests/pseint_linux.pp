# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::pseint_linux
class instalacionapps::pseint_linux {

  $version = '20250314'

  package { [
    'tar',
  ]:
    ensure => installed,
  }

  exec { 'descargar_pseint':
    command => "wget -O /tmp/pseint.tgz https://sourceforge.net/projects/pseint/files/20250314/pseint-l64-20250314.tgz/download",
    creates => '/tmp/pseint.tgz',
    require => Package['wget'],
	path    => ['/usr/bin', '/bin'],

  }

  exec { 'instalar_pseint':
    command => 'rm -rf /opt/pseint && mkdir -p /opt && tar -xzf /tmp/pseint.tgz -C /opt && mv /opt/pseint* /opt/pseint',
    creates => '/opt/pseint/pseint',
    require => Exec['descargar_pseint'],
	  path    => ['/usr/bin', '/bin'],

  }

  file { '/usr/local/bin/pseint':
    ensure  => link,
    target  => '/opt/pseint/pseint',
    require => Exec['instalar_pseint'],
  }

  file { '/usr/share/applications/pseint.desktop':
    ensure  => file,
    mode    => '0644',
    content => @("DESKTOP")
[Desktop Entry]
Name=PSeInt
Comment=Intérprete de pseudocódigo
Exec=/opt/pseint/pseint
Terminal=false
Type=Application
Categories=Education;Development;
Icon=/opt/pseint/imgs/pseint.png
DESKTOP
,
    require => Exec['instalar_pseint'],
  }



}
