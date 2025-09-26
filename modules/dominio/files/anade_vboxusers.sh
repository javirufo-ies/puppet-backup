#!/bin/bash
# Script PAM para añadir el usuario al grupo vboxusers
GROUP="vboxusers"
USER="${PAM_USER:-$1}"
[ -z "$USER" ] && USER="$PAM_RUSER"

if ! id -nG "$USER" | grep -qw "$GROUP"; then
    usermod -aG "$GROUP" "$USER"
fi
