# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include equipos::smr2d
class equipos::smr2d {
	if $::kernel == 'windows' {
		Package { provider => chocolatey, }
		package {'vscode':
			ensure => latest,
		}
		package {'python':
			ensure => present,
		}
		package {'xampp-81':
			ensure => present,
		}


 # --- Instalar Jupyter e ipykernel mediante pip ---
  exec { 'install jupyter':
    command => 'powershell -NoProfile -ExecutionPolicy Bypass -Command "python -m pip install --upgrade pip jupyter ipykernel"',
    unless  => 'powershell -NoProfile -Command "(pip show jupyter) -ne $null"',
    path    => ['C:\Python311', 'C:\Python311\Scripts', 'C:\Windows\System32'],
    require => Package['python'],
  }

  # --- Registrar el kernel (para VSCode o JupyterLab) ---
  exec { 'register ipykernel':
    command => 'powershell -NoProfile -ExecutionPolicy Bypass -Command "python -m ipykernel install --user"',
    unless  => 'powershell -NoProfile -Command "Test-Path $env:USERPROFILE\.local\share\jupyter\kernels\python3"',
    path    => ['C:\Python311', 'C:\Python311\Scripts', 'C:\Windows\System32'],
    require => Exec['install jupyter'],
  }



         }
}
