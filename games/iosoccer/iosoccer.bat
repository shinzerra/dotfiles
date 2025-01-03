@echo off
:: Set affinity and launch the game through Steam.
start /affinity 0xfe cmd.exe /c start steam://run/673560// -novid -high +exec autoexec.cfg
exit
