# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::pseint_linux
class instalacionapps::pseint_linux {

  $version = '20250314'

  package { [
    'wget',
    'tar',
  ]:
    ensure => installed,
  }

  exec { 'descargar_pseint':
    command => "wget -O /tmp/pseint.tgz https://downloads.sourceforge.net/project/pseint/PSeInt/${version}/pseint-l64-${version}.tgz",
    creates => '/tmp/pseint.tgz',
    require => Package['wget'],
  }

  exec { 'instalar_pseint':
    command => 'rm -rf /opt/pseint && mkdir -p /opt && tar -xzf /tmp/pseint.tgz -C /opt && mv /opt/pseint* /opt/pseint',
    creates => '/opt/pseint/pseint',
    require => Exec['descargar_pseint'],
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
    require => Exec['instalar_pseint'],
  }



}
