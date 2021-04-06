@echo off
set ~KN~LI=F:\LOGIN\LOGIN.EXE
set ~KN~LO=W:\PUBLIC\LOGOUT.EXE
if "%1"=="/k" goto KILLALL
if "%1"=="/K" goto KILLALL
if "%1"=="/?" goto KILLUSE
if "%1"=="" goto KILLCHK
echo.
echo Invalid option
goto :HELP
:KILLUSE
echo Use with no option to:
echo  1) log-off the net if necessary
echo  2) remove the net software from memory
echo.
echo Use option /K to kill the net with no prior log-in
echo  search. This may produce errors if not logged-in or
echo  the net software is not fully installed.
goto :END
:KILLCHK
if exist %~KN~LO% goto KILLALL
if exist %~KN~LI% goto KILLNET
echo Found no net to kill - assumes %~KN~LI%
echo  and %~KN~LO%
:HELP
echo.
echo Use option /? for help
goto END
:KILLALL
c:
%~KN~LO%
:KILLNET
c:
c:\novell\emsnetx /u
c:\novell\ipxodi /u
c:\novell\smc8000 u
c:\novell\lsl /u
:END
echo.
set ~KN~LI=
set ~KN~LO=
