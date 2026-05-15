class instalacionapps::deshabilitar_copilot {

  $policy_key = 'HKLM\Software\Policies\Microsoft\VSCode\Settings'

  registry::value { 'vscode-ai-hardlock':
    key  => $policy_key,
    name => '',
    type => 'string',
    data => @("JSON")
{
  // =========================
  // 🚫 IA / COPILOT BLOCK
  // =========================
  "github.copilot.enable": false,
  "github.copilot.chat.enabled": false,
  "chat.enabled": false,

  // =========================
  // 🚫 EXTENSION CONTROL
  // =========================
  "extensions.allowed": [
    "ms-python.python",
    "ms-vscode.cpptools",
	"vscode-live-server-plus-plus",
  ],

  // Bloquea instalación automática de extensiones recomendadas
  "extensions.autoCheckUpdates": false,
  "extensions.autoUpdate": false,

  // =========================
  // 🚫 MARKETPLACE CONTROL (parcial pero útil)
  // =========================
  "extensions.ignoreRecommendations": true,

  // =========================
  // 🔐 HARDENING UI / IA FEATURES
  // =========================
  "chat.experimental.enabled": false
}
JSON
  }

}
