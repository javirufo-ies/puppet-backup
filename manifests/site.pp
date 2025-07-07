
##################################
##	EQUIPOS PROFESOR	##
##################################



node /^dam1-pro/{
        notify {"Equipo DAM1 Profesor":}
        if $::kernel == 'windows' {
                Package {provider => chocolatey,}
		package {'rsat':
			ensure => present,
		}

        }
        include equipos::comunes
        include equipos::dam1
	include instalacionapps::veyonmaster
}


node /^daw1-pro/{
         notify {"Equipo DAW1 Profesor":}
         if $::kernel == 'windows' {
                 Package {provider => chocolatey,}
                package {'rsat':
                        ensure => present,
                }
         }
         include equipos::comunes
         include equipos::daw1
         include instalacionapps::veyonmaster
}


 node /^smr2v-pro/ {
         notify {"Equipo de SMR2V Profesor":}
         if $::kernel == 'windows' {
                 Package { provider => chocolatey, }
                package {'rsat':
                        ensure => present,
                }         
	}

         include equipos::comunes
         include equipos::smr2v
         include instalacionapps::veyonmaster
 
  }

node /^aula115-pro/ {
        notify {"Equipo de Aula115 profesor":}
        if $::kernel == 'windows' {
                Package { provider => chocolatey, }

		include instalacionapps::veyonmaster
		package {'rsat':
			ensure => present,
		}
        }

        include equipos::comunes
       include equipos::smr1d
#	include equipos::smr1v

}
node /^aula114-pro\.ciclos\.valledeljerte3/ {
        notify {"Equipo de Aula114 Profesor":}
        if $::kernel == 'windows' {
                Package { provider => chocolatey, }
                package {'rsat':
                        ensure => present,
                }
        }

        include equipos::comunes
        include equipos::smr2d
	include instalacionapps::veyonmaster
}

node /^taller1-pro\.ciclos\.valledeljerte3/ {
        notify {"Equipo de Taller1":}
        if $::kernel == 'windows' {
                Package { provider => chocolatey, }
                package {'rsat':
                        ensure => present,
                }
        }

        include equipos::comunes
        include equipos::iof1
	include instalacionapps::veyonmaster
}


node /^taller2-pro\.ciclos\.valledeljerte3/,"ttl-aio-taller2.ciclos.valledeljerte3" {
        notify {"Equipo de Taller2":}
        if $::kernel == 'windows' {
                Package { provider => chocolatey, }
                package {'rsat':
                        ensure => present,
                }
        }

        include equipos::comunes
        include equipos::iof2
	include instalacionapps::veyonmaster
}




##################################
##      EQUIPOS ALUMNADO        ##
##################################
node /^aula115-\d+/ {
	notify {"Equipo de Aula 115":}
        if $::kernel == 'windows' {
                Package { provider => chocolatey, }
	}

        include equipos::comunes
#	include equipos::comunes_alumnado
        include equipos::smr1d
#	include equipos::smr1v
}



node /^aula114-\d+/ {
	notify {"Equipo de Aula 114":}
        if $::kernel == 'windows' {
                Package { provider => chocolatey, }
        }

        include equipos::comunes
#	include equipos::comunes_alumnado
#       include equipos::smr2d

}


node /^dell-sku\d+\.ciclos\.valledeljerte3/ {
        notify {"Equipo de Aula2":}
        if $::kernel == 'windows' {
                Package { provider => chocolatey, }
        }

        include equipos::comunes
        include equipos::aula114

}

node /^dam1-\d+/{
	notify {"Equipo DAM1":}
	if $::kernel == 'windows' {
		Package {provider => chocolatey,}
	}
	include equipos::comunes
	include equipos::dam1
}


node /^daw1-\d+/{
          notify {"Equipo DAW1":}
          if $::kernel == 'windows' {
                  Package {provider => chocolatey,}
          }
          include equipos::comunes
          include equipos::daw1
}



node /^smr2v-\d+/ {
          notify {"Equipo de SMR2V":}
          if $::kernel == 'windows' {
                  Package { provider => chocolatey, }
          }

          include equipos::comunes
          include equipos::smr2v
}



node /^hp15s-sku\d+\.ciclos\.valledeljerte3/ {
        notify {"Equipo de Aula2":}
        if $::kernel == 'windows' {
                Package { provider => chocolatey, }
        }

        include equipos::comunes
        include equipos::aula114

}

node /^aula216-\d+\.ciclos\.valledeljerte3/ {
	notify {"Equipo de Aula216":}
        if $::kernel == 'windows' {
                Package { provider => chocolatey, }
        }

        include equipos::comunes
        include equipos::aula216

}

node /^departamento-\d+\.ciclos\.valledeljerte3/ {
	notify {"Equipo de departamento":}
        if $::kernel == 'windows' {
                Package { provider => chocolatey, }
        }

	include equipos::comunes
        include equipos::departamento

}

node /^portatil*\.ciclos\.valledeljerte3/ {
	notify {"Equipo portatil":}
        if $::kernel == 'windows' {
              Package { provider => chocolatey, }
        }

        include equipos::comunes
        include equipos::portatiles

}

node /^taller1-\d+\.ciclos\.valledeljerte3/ {
	notify {"Equipo de Taller1":}
        if $::kernel == 'windows' {
                Package { provider => chocolatey, }
        }

        include equipos::comunes
        include equipos::iof1
}

node /^taller2-.*\.ciclos\.valledeljerte3/ {
	notify {"Equipo de Taller2":}
        if $::kernel == 'windows' {
                Package { provider => chocolatey, }
        }

       include equipos::comunes
       include equipos::iof2

}


node /^vjyrv-\d+\.ciclos\.valledeljerte3/ {
        if $::kernel == 'windows' {
                Package { provider => chocolatey, }
        }

        include equipos::comunes
        include equipos::vjyrv

}

#node default {
#	notify {"Equipo por defecto":}
#       if $::kernel == 'windows' {
#                Package { provider => chocolatey, }
#        }
#	include equipos::comunes
#	include equipos::aula114
#}
