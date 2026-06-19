#!/bin/bash

# --- CONFIGURACIÓN ---
REPO_DIR="/etc/puppetlabs/code/environments/production"
MAX_SIZE="50M"          # Límite de tamaño (50 Megabytes). GitHub corta a 100MB por archivo.
COMMIT_MSG="Auto commit diario"
BRANCH="main"

# --- EJECUCIÓN ---
# Ir al directorio del repositorio
cd "$REPO_DIR" || { echo "❌ Error: No se encuentra el directorio $REPO_DIR"; exit 1; }

echo "🔄 Añadiendo cambios al área de preparación..."
git add -A

# Buscar archivos mayores al límite y quitarlos del staging area
echo "🔍 Buscando archivos mayores de $MAX_SIZE para excluir..."
# Usamos -print0 y read -d '' para manejar correctamente nombres de archivos con espacios
while IFS= read -r -d '' archivo; do
    echo "⚠️  Excluyendo archivo pesado: $archivo"
    # git reset HEAD quita el archivo del área de preparación (staging) sin borrarlo del disco
    git reset HEAD -- "$archivo" > /dev/null
done < <(find . -type f -size +$MAX_SIZE -not -path "./.git/*" -print0)

# Comprobar si hay algo que commitear (por si todos los cambios eran archivos pesados)
if git diff --cached --quiet; then
    echo "ℹ️  No hay cambios para commit (o todos los archivos superaban el límite)."
else
    # Hacer commit y push
    echo "💾 Haciendo commit..."
    git commit -m "$COMMIT_MSG"
    
    echo "🚀 Haciendo push a GitHub..."
    git push origin "$BRANCH"
    
    if [ $? -eq 0 ]; then
        echo "✅ Commit y push completados con éxito."
    else
        echo "❌ Error al hacer push."
    fi
fi
