echo off
setlocal

:: Set the Discord directory path
set "DiscordDir=%LocalAppData%\Discord"

:: Find the latest version folder in Discord directory
for /d %%i in ("%DiscordDir%\app-*") do set "LatestVersionDir=%%i"

:: Check if Discord.exe exists in the latest version directory
if exist "%LatestVersionDir%\Discord.exe" (
    :: Launch Discord with --start-minimized parameter and redirect output
    start "" /b "%LatestVersionDir%\Discord.exe" --start-minimized >nul 2>&1
) else (
    echo Discord.exe not found.
)

echo running thorium
:: Set the path to Thorium's executable
set "ThoriumPath=C:\Users\kayden\AppData\Local\Thorium\Application\thorium.exe"

:: Check if Thorium exists at the specified path
if exist "%ThoriumPath%" (
    :: Launch Thorium minimized and open SoundCloud
	echo opening soundcloud
    start "" /min "%ThoriumPath%" "https://soundcloud.com/"
) else (
    echo Thorium not found at the specified path.
)

echo starting obs with replay buffer
:: starting exe with replay buffer
start /d "C:\Program Files\obs-studio\bin\64bit" obs64.exe --startreplaybuffer --minimize-to-tray --disable-shutdown-check

echo starting sharex
:: starting exe with silent param
"C:\Program Files (x86)\Steam\steamapps\common\ShareX\ShareX_Launcher.exe" -silent

echo Killing Steam...
:: killing steam
taskkill /f /IM "steam.exe"

echo Checking for NoSteamWebHelper.exe...
:: checking if nowebhelper is already open
if not exist "C:\Program Files (x86)\Steam\NoSteamWebHelper.exe" (
    echo NoSteamWebHelper.exe not found.
    echo Make sure it is in the same folder as steam.exe.
    echo If you don't have it, get it from https://github.com/Aetopia/NoSteamWebHelper
    timeout /t 10 /nobreak
    exit /b
)

echo Running Steam...
:: launching steam without webhelper silently
start "" /b "C:\Program Files (x86)\Steam\NoSteamWebHelper.exe" -silent >nul 2>&1



endlocal
exit
