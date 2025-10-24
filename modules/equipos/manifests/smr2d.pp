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

	exec { 'install jupyter':
		command => 'c:\\Python313\\python.exe -m pip install --upgrade jupyter ipykernel',
		path    => ['C:\\Windows\\System32','C:\\Windows\\System32\\WindowsPowerShell\\v1.0','C:\\Python\\313','C:\\Python313\\Scripts'],
		unless  => 'c:\\Python313\\python.exe -m pip show jupyter',
	}

  # egistrar kernel de Jupyter para VS Code
	exec { 'register jupyter kernel':
		command => 'c:\\Python313\\python.exe -m ipykernel install --user --name=python --display-name "Python (Jupyter)"',
		path    => ['C:\\Windows\\System32','C:\\Windows\\System32\\WindowsPowerShell\\v1.0','C:\\Python\\313','C:\\Python313\\Scripts'],
#		unless  => 'if exist "%USERPROFILE%\\.local\\share\\jupyter\\kernels\\python" (exit 0) else (exit 1)',
		unless  => 'c:\\Python313\\python.exe -m pip show jupyter',
		
	}


#Fin Windows
         }
}
