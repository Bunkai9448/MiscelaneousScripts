REM Para convertir videos a un formato reproducible en televisores OKI modelo V19N-PHTUV


@echo off
setlocal enabledelayedexpansion

REM Define la carpeta de entrada aqui
set "INPUT_FOLDER=Marmalade"

REM Verifica si ffmpeg esta instalado
where ffmpeg >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo FFmpeg no esta instalado o no se encuentra en el PATH.
    echo Por favor, asegurate de que ffmpeg.exe este en la misma carpeta que este script o en el PATH del sistema.
    pause
    exit /b
)

REM Crea una carpeta de salida si no existe
if not exist "aVideo2TV" mkdir aVideo2TV

REM Verifica si la carpeta de entrada existe
if not exist "%INPUT_FOLDER%" (
    echo La carpeta '%INPUT_FOLDER%' no existe.
    pause
    exit /b
)

REM Procesa cada archivo de video en la carpeta de entrada
for %%F in ("%INPUT_FOLDER%\*.mkv" "%INPUT_FOLDER%\*.mp4") do (
    echo Procesando: %%F
    REM otras resoluciones que reconoce son: scale=720:540 ; scale=640:360
    ffmpeg -i "%%F" -vf scale=720:480:flags=lanczos -codec:v libxvid -b:v 1000k -codec:a libmp3lame -b:a 12k -af aresample=async=1 -f avi "aVideo2TV\tv_%%~nF.avi"
    REM cuando haya que incluir subs, tienen que ser hardsubs para que el bitrate no se exceda
    REM ffmpeg -i "%%F" -vf "scale=720:540:flags=lanczos,subtitles='%%~nF.srt'" -codec:v libxvid -b:v 1000k -codec:a libmp3lame -b:a 12k -af aresample=async=1 -f avi "aVideo2TV\tv_%%~nF.avi"
)

echo.
echo Conversion completada. Los archivos se encuentran en la carpeta 'aVideo2TV'.

pause
