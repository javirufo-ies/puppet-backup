# = Class: registry_example
#
#   This is an example of how to manage registry keys and values.
#
# = Parameters
#
# = Actions
#
# = Requires
#
# = Sample Usage
#
#     include registry_example
#
# (MARKUP: http://links.puppetlabs.com/puppet_manifest_documentation)
class registrowindows {
#JAVI 19/09/2019
#Eliminación de errores en registro para instalar google-drive-file-stream con $
  registry::value { 'HKLM\software\microsoft\windows\currentversion\uninstall\nb$
        ensure => absent,
#        type   => dword,
#        data => 1,
  }
  }


