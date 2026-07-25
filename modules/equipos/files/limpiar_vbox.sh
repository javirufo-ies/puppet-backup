#!/bin/bash

USUARIO="examen"
NOMBRE_BASE="Kali 2026"
RUTA_OVA="/var/tmp/kali.ova"
LOG_FILE="/var/log/puppet/limpieza_vbox.log"
HOME_USUARIP=$(grep ^$USUARIO: /etc/passwd|cut -d: -f 6)
mkdir -p /var/log/puppet 2> /dev/null

echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] === Iniciando revisión en cliente ===" >> "$LOG_FILE"
if [ ! -d $HOME_USUARIO ]; then
        echo "El directorio del usuario no existe" >> "$LOG_FILE"
        exit 0
fi


if [ ! -d $HOME_USUARIO/"VirtualBox VMs/" ]; then
        echo "El directorio de máquinas del usuario no existe" >> "$LOG_FILE"
        exit 0
fi

# 1. LIMPIEZA QUIRÚRGICA DE REGISTROS
sudo -H -u "$USUARIO" USER="$USUARIO" LOGNAME="$USUARIO" /usr/bin/VBoxManage list vms | grep -i "${NOMBRE_BASE}" | awk -F' ' '{print $NF}' | while read -r uuid; do
    echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] Borrando registro de VM corrupta/antigua: $uuid" >> "$LOG_FILE"
    sudo -H -u "$USUARIO" USER="$USUARIO" LOGNAME="$USUARIO" /usr/bin/VBoxManage unregistervm "$uuid" --delete >> "$LOG_FILE" 2>&1
done

# 2. LIMPIEZA RADICAL DE DIRECTORIOS HUÉRFANOS (Funde todas las carpetas)
echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] Limpiando carpetas físicas residuales de ${NOMBRE_BASE}..." >> "$LOG_FILE"

find "$HOME_USUARIO/VirtualBox VMs/" -maxdepth 1 -iname "${NOMBRE_BASE}*" -exec rm -rf {} + >> "$LOG_FILE" 2>&1

# 3. IMPORTACIÓN LIMPIA CORREGIDA (Sintaxis estricta para VirtualBox 7.0)
echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] Importando nueva versión de la máquina de examen..." >> "$LOG_FILE"
sudo -H -u "$USUARIO" USER="$USUARIO" LOGNAME="$USUARIO" /usr/bin/VBoxManage import --accept-all-licenses "$RUTA_OVA" --vsys 0 --vmname "${NOMBRE_BASE}" >> "$LOG_FILE" 2>&1

echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] === Proceso finalizado con éxito ===" >> "$LOG_FILE"





