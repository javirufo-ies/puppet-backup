#!/bin/bash
set -e

# 1. Obtener versión limpia (ej: 7.0.26)
VBOX_VER=$(vboxmanage -v)
# | cut -d'r' -f1)
# vboxmanage -v 2>/dev/null | grep -oE '^[0-9]+\.[0-9]+\.[0-9]+'
echo "1-->"$VBOX_VER
EXT_PACK="Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VER}.vbox-extpack"
echo "2-->"$EXT_PACK
TMP_FILE="/tmp/${EXT_PACK}"
echo "3-->"$TMP_FILE
echo "Detectada versión de VirtualBox: ${VBOX_VER}"

# 2. Descargar si no existe
if [ ! -f "$TMP_FILE" ]; then
    echo "Descargando ExtPack..."
    wget -q -O "$TMP_FILE" "https://download.virtualbox.org/virtualbox/${VBOX_VER}/${EXT_PACK}"
fi

# 3. Comprobar si ya está instalado y es la versión correcta
if VBoxManage list extpacks | grep -q "Version: ${VBOX_VER}"; then
    echo "El Extension Pack ${VBOX_VER} ya está instalado. Saliendo."
    exit 0
fi

# 4. Instalar aceptando la licencia (VirtualBox 7.0+)
echo "Instalando Extension Pack (aceptando licencia)..."
# En VB 7.0+, yes | a veces falla si no hay TTY. Usamos el flag de aceptación o yes forzado.
yes | VBoxManage extpack install --replace "$TMP_FILE" || \
VBoxManage extpack install --replace --accept-license=33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c "$TMP_FILE"

# 5. Limpieza
rm -f "$TMP_FILE"
echo "Instalación completada con éxito."
