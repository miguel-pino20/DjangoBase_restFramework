@echo off
REM ======================================
REM Script: create_app.bat
REM Uso: create_app.bat <nombre_app>
REM Crea una app Django con estructura API
REM ======================================

SET "APP_NAME=%~1"

IF "%APP_NAME%"=="" (
    ECHO ❌ Debes indicar el nombre de la app. Ejemplo:
    ECHO    create_app.bat canjes
    EXIT /B 1
)

REM Crear app base
python manage.py startapp %APP_NAME%

REM Verifica que se creó correctamente
IF NOT EXIST "%APP_NAME%" (
    ECHO ❌ No se pudo crear la app '%APP_NAME%'
    EXIT /B 1
)

REM ===============================
REM Crear estructura adicional
REM ===============================
IF NOT EXIST "%APP_NAME%\api" mkdir "%APP_NAME%\api"
IF NOT EXIST "%APP_NAME%\api\controllers" mkdir "%APP_NAME%\api\controllers"
IF NOT EXIST "%APP_NAME%\api\serializers" mkdir "%APP_NAME%\api\serializers"

REM Crear archivos base dentro de api/
type nul > "%APP_NAME%\api\__init__.py"
type nul > "%APP_NAME%\api\controller.py"
type nul > "%APP_NAME%\api\urls.py"
type nul > "%APP_NAME%\api\controllers\__init__.py"
type nul > "%APP_NAME%\api\serializers\__init__.py"

REM ===============================
REM Agregar contenido inicial
REM ===============================
(
echo from django.urls import path
echo from . import controller
echo.
echo urlpatterns = [
echo     #path('', include()),
echo ]
) > "%APP_NAME%\api\urls.py"

REM ===============================
REM Mensaje final
REM ===============================
ECHO ✅ App '%APP_NAME%' creada con estructura personalizada:
REM Mostrar árbol de directorios (requiere Windows 10+)
tree "%APP_NAME%" /A /I

