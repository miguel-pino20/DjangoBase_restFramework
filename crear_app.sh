#!/bin/bash
# ======================================
# Script: create_app.sh
# Uso: bash create_app.sh <nombre_app>
# Crea una app Django con estructura API
# ======================================

APP_NAME=$1

if [ -z "$APP_NAME" ]; then
  echo "❌ Debes indicar el nombre de la app. Ejemplo:"
  echo "   bash create_app.sh canjes"
  exit 1
fi

# Crear app base
python manage.py startapp $APP_NAME

# Verifica que se creó correctamente
if [ ! -d "$APP_NAME" ]; then
  echo "❌ No se pudo crear la app '$APP_NAME'"
  exit 1
fi

# ===============================
# Crear estructura adicional
# ===============================
mkdir -p $APP_NAME/api
mkdir -p $APP_NAME/api/controllers
mkdir -p $APP_NAME/api/serializers

# Crear archivos base dentro de api/
touch $APP_NAME/api/__init__.py
touch $APP_NAME/api/controller.py
touch $APP_NAME/api/urls.py
touch $APP_NAME/api/controllers/__init__.py
touch $APP_NAME/api/serializers/__init__.py

# ===============================
# Agregar contenido inicial
# ===============================
# urls.py
cat <<EOF > $APP_NAME/api/urls.py
from django.urls import path
from . import controller

urlpatterns = [
    #path('', include()),
]
EOF

# ===============================
# Mensaje final
# ===============================
echo "✅ App '$APP_NAME' creada con estructura personalizada:"
tree -I '__pycache__' $APP_NAME
