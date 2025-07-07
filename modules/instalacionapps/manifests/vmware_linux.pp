# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::vmware_linux
class instalacionapps::vmware_linux {


exec { 'copiar_vmware':
	command => "smbclient //10.0.0.21/Repositorio -N -c 'cd Instaladores; get VMware-Workstation-Full-17.6.3-24583834.x86_64.bundle /tmp/VMware.bundle'",
	creates => '/tmp/VMware.bundle',
	path =>	['/usr/bin', '/bin'],
}


exec { 'instalar_vmware':
  command => 'sh /tmp/VMware.bundle --eulas-agreed --console --required && rm /tmp/VMware.bundle',
  creates => '/usr/bin/vmware',
  path    => ['/bin', '/usr/bin'],
  require => Exec['copiar_vmware_desde_nfs'],
}





}
