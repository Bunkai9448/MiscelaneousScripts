@echo off

echo "Trae el archivo grabado"
move "C:\Users\Name\Videos\radio.mkv" "%cd%"

echo "Conviertelo a mp3"
ffmpeg -i "radio.mkv" -map 0:a -codec:a libmp3lame -b:a 128k "FM_OVF.mp3"

echo "Separa los audios en secciones para cada programa"
ffmpeg -i "FM_OVF.mp3" -ss 1:30:00.00 -to 4:00:59.00 -c copy "000_Have a good Day.mp3"

echo "Obten la fecha de hoy"
set weekday=Miercoles
for /f "tokens=1-3 delims=/ " %%a in ('date /t') do (
    set day=%%a
    set month=%%b
    set year=%%c
)

if "%month%"=="01" set month_name=enero
if "%month%"=="02" set month_name=febrero
if "%month%"=="03" set month_name=marzo
if "%month%"=="04" set month_name=abril
if "%month%"=="05" set month_name=mayo
if "%month%"=="06" set month_name=junio
if "%month%"=="07" set month_name=julio
if "%month%"=="08" set month_name=agosto
if "%month%"=="09" set month_name=septiembre
if "%month%"=="10" set month_name=octubre
if "%month%"=="11" set month_name=noviembre
if "%month%"=="12" set month_name=diciembre

echo "Crea carpeta para hoy"
mkdir "%year%-%month_name%-%day% %weekday%"
echo "Envia los audios de hoy a la carpeta"
move "*.mp3" ".\%year%-%month_name%-%day% %weekday%"

echo "Fin del script"
PAUSE
