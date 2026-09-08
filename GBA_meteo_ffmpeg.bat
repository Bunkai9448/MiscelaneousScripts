ffmpeg -i GBtrailerJPN.mp4 -vf "scale=240:160,fps=24" -c:v mpeg1video -qscale:v 2 -r 24 -c:a mp2 -ac 2 -ar 44100 -f mpeg "GBtrailerJPN_meteo.mpg"
pause