#!/bin/bash

USUARIO="examen"
NOMBRE_BASE="kali-linux-2026.1-virtualbox-amd64"
RUTA_OVA="/var/tmp/kali.ova"
LOG_FILE="/var/log/puppet/limpieza_vbox.log"

mkdir -p /var/log/puppet

echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] === Iniciando revisión en cliente ===" >> "$LOG_FILE"

# 1. LIMPIEZA QUIRÚRGICA DE REGISTROS
sudo -H -u "$USUARIO" USER="$USUARIO" LOGNAME="$USUARIO" /usr/bin/VBoxManage list vms | grep -i "${NOMBRE_BASE}" | awk -F' ' '{print $NF}' | while read -r uuid; do
    echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] Borrando registro de VM corrupta/antigua: $uuid" >> "$LOG_FILE"
    sudo -H -u "$USUARIO" USER="$USUARIO" LOGNAME="$USUARIO" /usr/bin/VBoxManage unregistervm "$uuid" --delete >> "$LOG_FILE" 2>&1
done

# 2. LIMPIEZA RADICAL DE DIRECTORIOS HUÉRFANOS (Funde las 44 carpetas)
echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] Limpiando carpetas físicas residuales de ${NOMBRE_BASE}..." >> "$LOG_FILE"
find "/home/${USUARIO}/VirtualBox VMs/" -maxdepth 1 -iname "${NOMBRE_BASE}*" -exec rm -rf {} + >> "$LOG_FILE" 2>&1

# 3. IMPORTACIÓN LIMPIA CORREGIDA (Sintaxis estricta para VirtualBox 7.0)
echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] Importando nueva versión de la máquina de examen..." >> "$LOG_FILE"
sudo -H -u "$USUARIO" USER="$USUARIO" LOGNAME="$USUARIO" /usr/bin/VBoxManage import --accept-all-licenses "$RUTA_OVA" --vsys 0 --vmname "${NOMBRE_BASE}" >> "$LOG_FILE" 2>&1

echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] === Proceso finalizado con éxito ===" >> "$LOG_FILE"
