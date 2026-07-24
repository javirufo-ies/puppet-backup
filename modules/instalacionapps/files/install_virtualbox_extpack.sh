#!/bin/bash


#!/bin/bash
set -e

VBOX_VER=$(VBoxManage -v | cut -d'r' -f1)

if VBoxManage list extpacks | grep -q "Version: ${VBOX_VER}"; then
    echo "El Extension Pack ${VBOX_VER} ya está instalado."
    exit 0
fi

EXTPACK_FILE="Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VER}.vbox-extpack"

echo "Instalando Extension Pack ${VBOX_VER}..."

wget -q -O "/tmp/${EXTPACK_FILE}" \
    "https://download.virtualbox.org/virtualbox/${VBOX_VER}/${EXTPACK_FILE}"

yes | VBoxManage extpack install --replace "/tmp/${EXTPACK_FILE}"

rm -f "/tmp/${EXTPACK_FILE}"



