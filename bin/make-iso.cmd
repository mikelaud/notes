@echo off
set script=%0
set src=%1
shift
shift
echo %script% %src%
pause
powershell.exe -ExecutionPolicy Bypass -noexit -file "make-iso.ps1" -src %src%
