#!/bin/bash

# Comprobar que se han pasado los dos argumentos requeridos
if [ $# -ne 2 ]; then
    echo "Uso: $0 <nombre_aula> <numero_equipos>"
    echo "Ejemplo: $0 aula115 36"
    exit 1
fi

AULA=$1
MAX_EQUIPOS=$2
DOMINIO="ciclos.valledeljerte3"

echo "=== INICIANDO LIMPIEZA DE CERTIFICADOS PARA EL $AULA ==="
echo "Equipos numéricos a procesar: 1 al $MAX_EQUIPOS"
echo "--------------------------------------------------------"

# Función auxiliar para revocar y limpiar de forma segura
limpiar_certificado() {
    local cert=$1
    echo "Procesando: $cert"
    
    # 1. Revocar el certificado
    puppetserver ca revoke --certname "$cert" 
    
    # 2. Limpiar los archivos del certificado
    puppetserver ca clean --certname "$cert" 
}

# 1. BUCLE PARA LOS EQUIPOS NUMÉRICOS
for ((i=1; i<=MAX_EQUIPOS; i++)); do
    # Formatear el número para que siempre tenga dos dígitos (ej: 1 -> 01, 10 -> 10)
    NUMERO=$(printf "%02d" $i)
    BASE_NAME="${AULA}-${NUMERO}"
    
    # Limpiar formato corto: aula115-01
    limpiar_certificado "$BASE_NAME"
    
    # Limpiar formato largo: aula115-01.ciclos.valledeljerte3
    limpiar_certificado "${BASE_NAME}.${DOMINIO}"
done

# 2. CASO ESPECIAL: EL EQUIPO "pro"
echo "--------------------------------------------------------"
echo "Procesando caso especial: equipo 'pro'"
BASE_PRO="${AULA}-pro"

# Limpiar formato corto: aula115-pro
limpiar_certificado "$BASE_PRO"

# Limpiar formato largo: aula115-pro.ciclos.valledeljerte3
limpiar_certificado "${BASE_PRO}.${DOMINIO}"

echo "--------------------------------------------------------"
echo "=== LIMPIEZA FINALIZADA PARA EL $AULA ==="
