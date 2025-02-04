@echo off
setlocal
cls

:: move this to C:\Users\k\AppData\Roaming\Microsoft\Windows\SendTo


if "%~1"=="" (
    echo No file selected. Please use "Send to" on an .exe file.
    pause
    exit /b
)

set "application=%~1"
set "PROFILENAME=%~n1"

echo adding qos and fse to: %application%
timeout /t 2 > nul

:: Apply QoS DSCP 46 Policy
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\%PROFILENAME%" /v "Version" /t REG_SZ /d "1.0" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\%PROFILENAME%" /v "Application Name" /t REG_SZ /d "%application%" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\%PROFILENAME%" /v "Protocol" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\%PROFILENAME%" /v "Local Port" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\%PROFILENAME%" /v "Remote Port" /t REG_SZ /d "*" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\%PROFILENAME%" /v "DSCP Value" /t REG_SZ /d "46" /f > NUL 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\%PROFILENAME%" /v "Throttle Rate" /t REG_SZ /d "-1" /f > NUL 2>&1

:: exclusive fullscreen high dpi
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%application%" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE HIGHDPIAWARE" /f > NUL 2>&1

:: high performance gpu setting
Reg.exe add "HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "%application%" /t REG_SZ /d "GpuPreference=2;" /f > NUL 2>&1

cls
echo qos and fse added for:
echo %application%
pause
exit
