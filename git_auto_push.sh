#!/bin/bash

REPO="/etc/puppetlabs/code/environments/production"

cd "$REPO" || exit 1

# Asegurar identidad (por si cron no la tiene)
export GIT_SSH_COMMAND="ssh -o BatchMode=yes"

# Añadir cambios
git add -A

# Solo hacer commit si hay cambios
if ! git diff --cached --quiet; then
    git commit -m "Auto commit diario $(date +%F_%H:%M)"
    git push origin main
fi
