@echo off
REM =====================================================
REM Script: create_api_files.bat
REM Uso: create_api_files <nombre_app>
REM Genera archivos controller y serializer por cada modelo en models.py
REM =====================================================

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo ❌ Debes indicar el nombre de la app. Ejemplo:
    echo    create_api_files canjes
    exit /b
)

set APP_NAME=%~1
set APP_PATH=%APP_NAME%
set MODELS_FILE=%APP_PATH%\models.py

if not exist "%MODELS_FILE%" (
    echo ❌ No se encontró el archivo %MODELS_FILE%
    exit /b
)

set CONTROLLERS_DIR=%APP_PATH%\api\controllers
set SERIALIZERS_DIR=%APP_PATH%\api\serializers

if not exist "%CONTROLLERS_DIR%" (
    echo ❌ No existe la carpeta %CONTROLLERS_DIR%
    exit /b
)
if not exist "%SERIALIZERS_DIR%" (
    echo ❌ No existe la carpeta %SERIALIZERS_DIR%
    exit /b
)

echo =====================================================
echo ✅ Leyendo clases desde %MODELS_FILE%
echo =====================================================

for /f "tokens=2 delims= " %%A in ('findstr /R "^class " "%MODELS_FILE%"') do (
    set MODEL=%%A
    for /f "tokens=1 delims=(" %%B in ("!MODEL!") do (
        set MODEL_NAME=%%B

        echo.
        echo ➤ Procesando modelo: !MODEL_NAME!

        set CONTROLLER_FILE=%CONTROLLERS_DIR%\!MODEL_NAME!.py
        set SERIALIZER_FILE=%SERIALIZERS_DIR%\!MODEL_NAME!Serializers.py

        REM Crear controller
        if not exist "!CONTROLLER_FILE!" (
            echo # Controller para el modelo !MODEL_NAME!> "!CONTROLLER_FILE!"
            echo from rest_framework import viewsets>> "!CONTROLLER_FILE!"
            echo from ..serializers.!MODEL_NAME!Serializers import !MODEL_NAME!Serializer>> "!CONTROLLER_FILE!"
            echo from ...models import !MODEL_NAME!>> "!CONTROLLER_FILE!"
            echo.>> "!CONTROLLER_FILE!"
            echo class !MODEL_NAME!ViewSet(viewsets.ModelViewSet):>> "!CONTROLLER_FILE!"
            echo     queryset = !MODEL_NAME!.objects.all()>> "!CONTROLLER_FILE!"
            echo     serializer_class = !MODEL_NAME!Serializer>> "!CONTROLLER_FILE!"
            echo 🟢 Creado: !CONTROLLER_FILE!
        ) else (
            echo ⚠️  Ya existe: !CONTROLLER_FILE!
        )

        REM Crear serializer
        if not exist "!SERIALIZER_FILE!" (
            echo # Serializer para el modelo !MODEL_NAME!> "!SERIALIZER_FILE!"
            echo from rest_framework import serializers>> "!SERIALIZER_FILE!"
            echo from ...models import !MODEL_NAME!>> "!SERIALIZER_FILE!"
            echo.>> "!SERIALIZER_FILE!"
            echo class !MODEL_NAME!Serializer(serializers.ModelSerializer):>> "!SERIALIZER_FILE!"
            echo     class Meta:>> "!SERIALIZER_FILE!"
            echo         model = !MODEL_NAME!>> "!SERIALIZER_FILE!"
            echo         fields = '__all__'>> "!SERIALIZER_FILE!"
            echo 🟢 Creado: !SERIALIZER_FILE!
        ) else (
            echo ⚠️  Ya existe: !SERIALIZER_FILE!
        )
    )
)

echo.
echo 🎯 Finalizado con éxito.
endlocal
