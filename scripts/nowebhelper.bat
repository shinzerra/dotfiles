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

echo Waiting for 5 seconds before closing...
timeout /t 5 /nobreak
