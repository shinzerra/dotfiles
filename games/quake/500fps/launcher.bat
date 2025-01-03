@echo off
cd "C:\Program Files (x86)\Steam\steamapps\common\Quake Live"
start "" "quakelive_steam.exe"

timeout /t 10 /nobreak > nul
start "" "C:\qlfps\QuakeLive500FPS.exe"

timeout /t 10 /nobreak > nul
start "" "C:\Program Files (x86)\RivaTuner Statistics Server\RTSS.exe"

timeout /t 10 /nobreak > nul
taskkill /im QuakeLive500FPS.exe /f

exit
