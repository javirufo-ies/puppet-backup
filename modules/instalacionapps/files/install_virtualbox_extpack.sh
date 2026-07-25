#!/bin/bash
set -e

# 1. Evitar warnings de VirtualBox en TODAS las llamadas
export LOGNAME=root USER=root

# 2. Obtener versión limpia (ej: 7.2.14)
VBOX_VER=$(vboxmanage -v 2>/dev/null | grep -oE '^[0-9]+\.[0-9]+\.[0-9]+')
if [ -z "$VBOX_VER" ]; then
    echo "ERROR: No se pudo detectar la versión de VirtualBox"
    exit 1
fi

EXT_PACK="Oracle_VirtualBox_Extension_Pack-${VBOX_VER}.vbox-extpack"
TMP_FILE="/tmp/${EXT_PACK}"
URL="https://download.virtualbox.org/virtualbox/${VBOX_VER}/${EXT_PACK}"

echo "Detectada versión de VirtualBox: ${VBOX_VER}"
echo "URL de descarga: ${URL}"

# 3. Comprobar si ya está instalado y es la versión correcta
if VBoxManage list extpacks | grep -q "Version: ${VBOX_VER}"; then
    echo "El Extension Pack ${VBOX_VER} ya está instalado. Saliendo."
    exit 0
fi

# 4. IMPORTANTE: Borrar archivo temporal previo (evita usar uno corrupto de intentos anteriores)
rm -f "$TMP_FILE"

# 5. Descargar (sin -q para ver errores, y verificando código de retorno)
echo "Descargando ExtPack..."
if ! wget --tries=2 -O "$TMP_FILE" "$URL"; then
    echo "ERROR: Falló la descarga del ExtPack desde ${URL}"
    exit 1
fi

# 6. Verificar que el archivo descargado no sea un HTML de error (ej: un 404 de Oracle)
if file "$TMP_FILE" | grep -q "HTML"; then
    echo "ERROR: El archivo descargado no es válido (posible error 404 de Oracle)."
    echo "Contenido del archivo descargado:"
    cat "$TMP_FILE"
    exit 1
fi

# 7. Instalar aceptando la licencia
echo "Instalando Extension Pack..."
yes | VBoxManage extpack install --replace "$TMP_FILE"

# 8. Limpieza
rm -f "$TMP_FILE"
echo "Instalación completada con éxito."
