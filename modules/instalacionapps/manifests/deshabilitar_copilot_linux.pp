# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include instalacionapps::deshabilitar_copilot_linux
class instalacionapps::deshabilitar_copilot_linux {

  # Configuración global de VS Code
  file { '/etc/vscode-policies':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/vscode-policies/settings.json':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/vscode-policies'],
    content => @("JSON")
{
  "github.copilot.enable": {
    "*": false
  },
  "github.copilot.chat.enabled": false,
  "chat.enabled": false,
  "chat.experimental.enabled": false,

  "extensions.autoCheckUpdates": false,
  "extensions.autoUpdate": false,
  "extensions.ignoreRecommendations": true,

  "telemetry.telemetryLevel": "off"
}
JSON
  }

  # Desinstalar Copilot si existe
  exec { 'uninstall_github_copilot':
    command => '/usr/bin/code --uninstall-extension GitHub.copilot',
    onlyif  => '/usr/bin/code --list-extensions | grep -iq "^github\.copilot$"',
    path    => ['/usr/bin', '/bin'],
  }

  exec { 'uninstall_github_copilot_chat':
    command => '/usr/bin/code --uninstall-extension GitHub.copilot-chat',
    onlyif  => '/usr/bin/code --list-extensions | grep -iq "^github\.copilot-chat$"',
    path    => ['/usr/bin', '/bin'],
  }

  # Limpiar extensiones instaladas por los usuarios
  exec { 'purge_copilot_extensions':
    command => '/usr/bin/find /home -type d \( -iname "github.copilot*" -o -iname "github.copilot-chat*" \) -exec rm -rf {} +',
    path    => ['/usr/bin', '/bin'],
  }

  # Limpiar también perfiles de VS Code Server
  exec { 'purge_copilot_vscode_server':
    command => '/usr/bin/find /home -path "*/.vscode-server/extensions/github.copilot*" -exec rm -rf {} +',
    path    => ['/usr/bin', '/bin'],
  }

  # Crear configuración por defecto para nuevos usuarios
  file { '/etc/skel/.config/Code/User':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/skel/.config/Code/User/settings.json':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/skel/.config/Code/User'],
    content => @("JSON")
{
  "github.copilot.enable": {
    "*": false
  },
  "github.copilot.chat.enabled": false,
  "chat.enabled": false,
  "chat.experimental.enabled": false,
  "extensions.autoCheckUpdates": false,
  "extensions.autoUpdate": false,
  "extensions.ignoreRecommendations": true
}
JSON
  }

  # Aplicar configuración a usuarios existentes
  exec { 'apply_vscode_settings_to_existing_users':
    command => '/bin/bash -c \'for d in /home/*; do if [ -d "$d" ]; then mkdir -p "$d/.config/Code/User"; cp -f /etc/skel/.config/Code/User/settings.json "$d/.config/Code/User/settings.json"; chown -R $(basename "$d"):$(basename "$d") "$d/.config"; fi; done\'',
    require => File['/etc/skel/.config/Code/User/settings.json'],
    path    => ['/usr/bin', '/bin'],
  }

}
