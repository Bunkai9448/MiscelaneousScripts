REM Para convertir audios a un formato reproducible en televisores OKI modelo V19N-PHTUV


@echo off
setlocal enabledelayedexpansion

REM Define la carpeta de entrada aqui
set "INPUT_FOLDER=2025-julio"

REM Verifica si ffmpeg esta instalado
where ffmpeg >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo FFmpeg no esta instalado o no se encuentra en el PATH.
    echo Por favor, asegurate de que ffmpeg.exe este en la misma carpeta que este script o en el PATH del sistema.
    pause
    exit /b
)

REM Crea una carpeta de salida si no existe
if not exist "AudioEnTV" mkdir AudioEnTV

REM Verifica si la carpeta de entrada existe
if not exist "%INPUT_FOLDER%" (
    echo La carpeta '%INPUT_FOLDER%' no existe.
    pause
    exit /b
)

REM Procesa cada archivo MP3 en la carpeta de entrada
for %%F in ("%INPUT_FOLDER%\*.mp3" "%INPUT_FOLDER%\*.m4a" "%INPUT_FOLDER%\*.aac" "%INPUT_FOLDER%\*.flac") do (
    echo Procesando: %%F
    ffmpeg -i "%%F" -codec:a libmp3lame -b:a 128k -f mp3 "AudioEnTV\tv_%%~nF.mp3"
)

echo.
echo Conversion completada. Los archivos se encuentran en la carpeta 'AudioEnTV'.

pause
