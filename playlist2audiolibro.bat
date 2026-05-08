@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

set "BOOK_TITLE=ことわざ"
echo Creando audiolibro: %BOOK_TITLE%

echo ================================
echo 1. Convertir archivos a WAV
echo ================================

if exist temp_audio rmdir /s /q temp_audio
mkdir temp_audio

for /f "delims=" %%f in ('dir /b /on *.mp3 *.m4a *.opus *.webm 2^>nul') do (
    ffmpeg -v error -err_detect ignore_err -fflags +discardcorrupt ^
    -i "%%f" -ar 44100 -ac 2 -c:a pcm_s16le ^
    "temp_audio\%%~nf.wav"
)

echo ================================
echo 2. Crear lista de archivos
echo ================================

if exist lista.txt del lista.txt

for /f "delims=" %%f in ('dir /b /on temp_audio\*.wav 2^>nul') do (
    echo file 'temp_audio/%%f'>>lista.txt
)

echo ================================
echo 3. Crear metadata base
echo ================================

if exist metadata.txt del metadata.txt
echo ;FFMETADATA1>metadata.txt

set START=0

for /f "delims=" %%f in ('dir /b /on temp_audio\*.wav 2^>nul') do (
    set "NAME=%%~nf"

    for /f "tokens=*" %%d in ('
        ffprobe -v error -show_entries format^=duration -of default^=nw^=1:nk^=1 "temp_audio\%%f"
    ') do set "DUR=%%d"

    if not defined DUR set "DUR=1"
    set "DUR=!DUR:,=.!"

    for /f %%e in ('
        powershell -NoProfile -Command ^
        "$s=[double]('%START%'); $d=[double]('%DUR%'); [int][math]::Round($s + ($d*1000),0)"
    ') do set "END=%%e"

    if not defined END set "END=!START!"

    >>metadata.txt echo [CHAPTER]
    >>metadata.txt echo TIMEBASE=1/1000
    >>metadata.txt echo START=!START!
    >>metadata.txt echo END=!END!
    >>metadata.txt echo title=!NAME!

    set START=!END!
)

echo ================================
echo 4. Crear audiolibro m4b
echo ================================

ffmpeg -y -f concat -safe 0 -i lista.txt -i metadata.txt -i cover.jpg ^
-map 0:a -map 2:0 ^
-c:a aac -b:a 64k ^
-c:v mjpeg ^
-disposition:v:0 attached_pic ^
-metadata title="%BOOK_TITLE%" ^
-movflags +faststart ^
audiolibro.m4b

echo ================================
echo Limpieza
echo ================================

rmdir /s /q temp_audio

echo.
echo Audiolibro creado correctamente
pause