#!/bin/bash

NAS_MOUNT="/mnt/isos"
DESKTOP="${HOME}/Desktop"
LINK="${DESKTOP}/Repositorio_ISOS.desktop"

# Crear Desktop si no existe
mkdir -p "${DESKTOP}"

# Crear el enlace .desktop solo si no existe
if [ ! -f "${LINK}" ]; then
    cat <<EOF > "${LINK}"
[Desktop Entry]
Type=Link
Name=Repositorio ISOS
Comment=Acceso al NAS
Icon=folder
URL=file://${NAS_MOUNT}
EOF
    chown "$USER":"$USER" "${LINK}"
    chmod 644 "${LINK}"
fi
