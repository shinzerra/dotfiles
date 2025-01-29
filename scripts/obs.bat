echo off
setlocal
echo starting obs with replay buffer
:: starting exe with replay buffer
start /d "C:\Program Files\obs-studio\bin\64bit" obs64.exe --startreplaybuffer --minimize-to-tray --disable-shutdown-check
