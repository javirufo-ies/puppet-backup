# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::packettracer_linux
class instalacionapps::packettracer_linux {
}
class instalacionapps::virtualbox_linux {

  # Dependencias necesarias
  package { ['wget', 'gnupg']: ensure => installed }

  # Añadir la clave pública de Oracle para VirtualBox → usando keyring
  exec { 'add_virtualbox_key':
    command => 'wget -qO- https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor | tee /etc/apt/keyrings/oracle-virtualbox.gpg > /dev/null',
    creates => '/etc/apt/keyrings/oracle-virtualbox.gpg',
    path    => ['/usr/bin', '/bin'],
  }

  # Configurar el repositorio oficial de VirtualBox (Ubuntu/Debian)
  exec { 'add_virtualbox_repo':
    command => 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/oracle-virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian noble contrib" > /etc/apt/sources.list.d/virtualbox.list && apt-get update',
    unless  => 'test -f /etc/apt/sources.list.d/virtualbox.list',
    require => Exec['add_virtualbox_key'],
    path    => ['/usr/bin', '/bin'],
  }

  # Instalación de VirtualBox
  package { 'virtualbox-7.0':
    ensure  => present,
    require => Exec['add_virtualbox_repo'],
  }





  # Instalación del Extension Pack
  $extpack_version = '7.0.18'
  $extpack_file = "Oracle_VM_VirtualBox_Extension_Pack-${extpack_version}.vbox-extpack"
  $extpack_url = "https://download.virtualbox.org/virtualbox/${extpack_version}/${extpack_file}"

  exec { 'download_virtualbox_extpack':
    command => "/usr/bin/wget -O /tmp/${extpack_file} ${extpack_url}",
    creates => "/tmp/${extpack_file}",
    require => Package['virtualbox-7.0'],
  }

  exec { 'install_virtualbox_extpack':
    command => "yes | /usr/bin/VBoxManage extpack install --replace /tmp/${extpack_file}",
    unless  => "/usr/bin/VBoxManage list extpacks | grep -q 'Version: ${extpack_version}'",
    require => Exec['download_virtualbox_extpack'],
    path    => ['/usr/bin', '/bin'],
  }

}
