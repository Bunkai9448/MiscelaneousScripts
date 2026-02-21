@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

set "BOOK_TITLE=Ｎ１文法"
echo Creando audiolibro: %BOOK_TITLE%

echo Crear lista de archivos
if exist lista.txt del lista.txt
for /f "delims=" %%f in ('dir /b *.mp3') do (
    echo file '%%f'>>lista.txt
)

echo Crear metadata base
if exist metadata.txt del metadata.txt
echo ;FFMETADATA1>metadata.txt

set START=0

for /f "delims=" %%f in ('dir /b *.mp3') do (
    set "NAME=%%~nf"

    for /f "tokens=*" %%d in ('ffprobe -v error -show_entries format^=duration -of default^=nw^=1:nk^=1 "%%f"') do set DUR=%%d

    for /f %%e in ('powershell -NoProfile -Command "[math]::Round((!START! + (!DUR! * 1000)),0)"') do set END=%%e

    >>metadata.txt echo [CHAPTER]
    >>metadata.txt echo TIMEBASE=1/1000
    >>metadata.txt echo START=!START!
    >>metadata.txt echo END=!END!
    >>metadata.txt echo title=!NAME!

    set START=!END!
)

echo Crear audiolibro m4b
ffmpeg -f concat -safe 0 -i lista.txt -i metadata.txt -map_metadata 1 -c:a aac -b:a 64k -metadata title="%BOOK_TITLE%" -metadata encoding=UTF-8 audiolibro.m4b

echo.
echo Audiolibro creado correctamente
pause