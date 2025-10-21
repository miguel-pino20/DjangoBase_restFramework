@echo off
REM =====================================================
REM Script: create_api_files.bat
REM Uso: create_api_files.bat <nombre_app>
REM Genera archivos controller y serializer por cada modelo
REM =====================================================

setlocal ENABLEDELAYEDEXPANSION

set APP_NAME=%1

if "%APP_NAME%"=="" (
    echo ❌ Debes indicar el nombre de la app. Ejemplo:
    echo    create_api_files.bat canjes
    exit /b 1
)

set APP_PATH=%APP_NAME%
set MODELS_FILE=%APP_PATH%\models.py

if not exist "%MODELS_FILE%" (
    echo ❌ No se encontró el archivo %MODELS_FILE%
    exit /b 1
)

REM Directorios destino
set CONTROLLERS_DIR=%APP_PATH%\api\controllers
set SERIALIZERS_DIR=%APP_PATH%\api\serializers

REM Crear los directorios si no existen
if not exist "%CONTROLLERS_DIR%" mkdir "%CONTROLLERS_DIR%"
if not exist "%SERIALIZERS_DIR%" mkdir "%SERIALIZERS_DIR%"

REM Buscar las clases dentro de models.py
for /f "tokens=2 delims= " %%A in ('findstr /r "^class " "%MODELS_FILE%"') do (
    set MODEL_NAME=%%A
    for /f "tokens=1 delims=(" %%B in ("!MODEL_NAME!") do (
        call :process_model %%B
    )
)

echo.
echo 🎯 Finalizado con éxito.
exit /b

:process_model
set MODEL=%1

echo ✅ Procesando modelo: %MODEL%

set CONTROLLER_FILE=%CONTROLLERS_DIR%\%MODEL%.py
set SERIALIZER_FILE=%SERIALIZERS_DIR%\%MODEL%Serializers.py

REM Crear controller si no existe
if not exist "%CONTROLLER_FILE%" (
    (
        echo # Controller para el modelo %MODEL%
        echo from rest_framework import viewsets
        echo from ..serializers.%MODEL%Serializers import %MODEL%Serializer
        echo from ...models import %MODEL%
        echo.
        echo class %MODEL%ViewSet(viewsets.ModelViewSet^):
        echo ^    queryset = %MODEL%.objects.all()
        echo ^    serializer_class = %MODEL%Serializer
    ) > "%CONTROLLER_FILE%"
    echo 🟢 Creado: %CONTROLLER_FILE%
) else (
    echo ⚠️  Ya existe: %CONTROLLER_FILE%
)

REM Crear serializer si no existe
if not exist "%SERIALIZER_FILE%" (
    (
        echo # Serializer para el modelo %MODEL%
        echo from rest_framework import serializers
        echo from ...models import %MODEL%
        echo.
        echo class %MODEL%Serializer(serializers.ModelSerializer^):
        echo ^    class Meta:
        echo ^        model = %MODEL%
        echo ^        fields = '__all__'
    ) > "%SERIALIZER_FILE%"
    echo 🟢 Creado: %SERIALIZER_FILE%
) else (
    echo ⚠️  Ya existe: %SERIALIZER_FILE%
)

exit /b
