#!/bin/bash
# =====================================================
# Script: create_api_files.sh
# Uso: bash create_api_files.sh <nombre_app>
# Genera archivos controller y serializer por cada modelo
# =====================================================

APP_NAME=$1

if [ -z "$APP_NAME" ]; then
  echo "❌ Debes indicar el nombre de la app. Ejemplo:"
  echo "   bash create_api_files.sh canjes"
  exit 1
fi

APP_PATH="$APP_NAME"
MODELS_FILE="$APP_PATH/models.py"

if [ ! -f "$MODELS_FILE" ]; then
  echo "❌ No se encontró el archivo $MODELS_FILE"
  exit 1
fi

# Directorios destino
CONTROLLERS_DIR="$APP_PATH/api/controllers"
SERIALIZERS_DIR="$APP_PATH/api/serializers"

# Crear los directorios si no existen
mkdir -p "$CONTROLLERS_DIR"
mkdir -p "$SERIALIZERS_DIR"

# Buscar las clases dentro de models.py
MODEL_NAMES=$(grep -E '^class ' "$MODELS_FILE" | awk '{print $2}' | cut -d'(' -f1)

if [ -z "$MODEL_NAMES" ]; then
  echo "⚠️  No se encontraron clases en $MODELS_FILE"
  exit 0
fi

echo "✅ Se encontraron los siguientes modelos:"
echo "$MODEL_NAMES"
echo ""

# Crear archivos para cada modelo
for MODEL in $MODEL_NAMES; do
  CONTROLLER_FILE="$CONTROLLERS_DIR/${MODEL}.py"
  SERIALIZER_FILE="$SERIALIZERS_DIR/${MODEL}Serializers.py"

  # Crear controller
  if [ ! -f "$CONTROLLER_FILE" ]; then
    cat <<EOF > "$CONTROLLER_FILE"
# Controller para el modelo $MODEL
from rest_framework import viewsets
from ..serializers.${MODEL}Serializers import ${MODEL}Serializer
from ...models import ${MODEL}

class ${MODEL}ViewSet(viewsets.ModelViewSet):
    queryset = ${MODEL}.objects.all()
    serializer_class = ${MODEL}Serializer
EOF
    echo "🟢 Creado: $CONTROLLER_FILE"
  else
    echo "⚠️  Ya existe: $CONTROLLER_FILE"
  fi

  # Crear serializer
  if [ ! -f "$SERIALIZER_FILE" ]; then
    cat <<EOF > "$SERIALIZER_FILE"
# Serializer para el modelo $MODEL
from rest_framework import serializers
from ...models import ${MODEL}

class ${MODEL}Serializer(serializers.ModelSerializer):
    class Meta:
        model = ${MODEL}
        fields = '__all__'
EOF
    echo "🟢 Creado: $SERIALIZER_FILE"
  else
    echo "⚠️  Ya existe: $SERIALIZER_FILE"
  fi

done

echo ""
echo "🎯 Finalizado con éxito."
