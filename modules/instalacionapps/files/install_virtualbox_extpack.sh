#!/bin/bash
set -e

# 1. Evitar warnings de VirtualBox en TODAS las llamadas
export LOGNAME=root USER=root HOME=/root

# 2. Obtener versión limpia (ej: 7.2.14)
VBOX_VER=$(vboxmanage -v 2>/dev/null | grep -oE '^[0-9]+\.[0-9]+\.[0-9]+')
if [ -z "$VBOX_VER" ]; then
    echo "ERROR: No se pudo detectar la versión de VirtualBox"
    exit 1
fi

# CORRECCIÓN CRÍTICA: El nombre oficial de Oracle incluye "_VM_"
EXT_PACK="Oracle_VirtualBox_Extension_Pack-${VBOX_VER}.vbox-extpack"
TMP_FILE="/tmp/${EXT_PACK}"
URL="https://download.virtualbox.org/virtualbox/${VBOX_VER}/${EXT_PACK}"

echo "Detectada versión de VirtualBox: ${VBOX_VER}"

# 3. Comprobar si YA está instalado y es la versión correcta
# Usamos grep -qi para ser insensibles a mayúsculas/minúsculas y posibles variaciones de formato
if VBoxManage list extpacks 2>/dev/null | grep -qi "${VBOX_VER}"; then
    echo "El Extension Pack v${VBOX_VER} YA está instalado. No se hace nada."
    exit 0
fi

echo "El Extension Pack no está instalado o la versión no coincide. Procediendo..."

# 4. Descargar SOLO si no existe o el archivo es demasiado pequeño (posible descarga fallida previa)
# Un Extension Pack real pesa más de 10MB (10000000 bytes)
if [ -f "$TMP_FILE" ] && [ "$(stat -c%s "$TMP_FILE" 2>/dev/null || echo 0)" -gt 10000000 ]; then
    echo "El archivo temporal ya existe y parece válido (>10MB). Omitiendo descarga."
else
    echo "Descargando ExtPack desde: ${URL}"
    rm -f "$TMP_FILE" # Limpieza previa por seguridad
    
    if ! wget --tries=2 -O "$TMP_FILE" "$URL"; then
        echo "ERROR: Falló la descarga del ExtPack."
        exit 1
    fi

    # Verificar que Oracle no haya devuelto un HTML de error 404
    if file "$TMP_FILE" | grep -qi "HTML"; then
        echo "ERROR: El archivo descargado no es válido (posible error 404 de Oracle)."
        echo "Contenido del archivo:"
        cat "$TMP_FILE"
        rm -f "$TMP_FILE"
        exit 1
    fi
fi

# 5. Instalar aceptando la licencia
echo "Instalando Extension Pack..."
yes | VBoxManage extpack install --replace "$TMP_FILE"

# 6. Limpieza final
rm -f "$TMP_FILE"
echo "Instalación completada con éxito."
