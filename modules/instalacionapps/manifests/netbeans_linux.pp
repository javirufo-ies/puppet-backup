# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::netbeans_linux
class instalacionapps::netbeans_linux {

package { [
    'snapd',
    'openjdk-21-jdk',
  ]:
    ensure => installed,
  }

  exec { 'install_netbeans_snap':
    command => '/usr/bin/snap install netbeans --classic',
    unless  => '/usr/bin/snap list netbeans >/dev/null 2>&1',
    require => [
      Package['snapd'],
      Package['openjdk-21-jdk'],
    ],
    path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
  }

  exec { 'set_default_java':
    command => '/usr/bin/update-alternatives --set java /usr/lib/jvm/java-21-openjdk-amd64/bin/java',
    onlyif  => '/usr/bin/test -x /usr/lib/jvm/java-21-openjdk-amd64/bin/java',
    require => Package['openjdk-21-jdk'],
  }

}

