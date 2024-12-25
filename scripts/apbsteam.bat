@echo off

echo killing steam
taskkill /f /IM "steam.exe"

echo checking for NoSteamWebHelper.exe

if not exist "C:\Program Files (x86)\Steam\NoSteamWebHelper.exe" (
    echo NoSteamWebHelper.exe not found.
    echo make sure it is in the same folder as steam.exe.
    echo if you don't have it, get it from https://github.com/Aetopia/NoSteamWebHelper
    timeout /t 10 /nobreak
    exit /b
)

echo running steam
"C:\Program Files (x86)\Steam\NoSteamWebHelper.exe" -silent

echo starting apb
"C:\Program Files (x86)\Steam\steamapps\common\APB Reloaded\Binaries\APB.exe" -nomovies -nosplash -language=1031 -slient
timeout /t 5 /nobreak
