@echo off
set ~grpopt=
set ~grpf_p=
set ~grpout=con
set ~grptmp=grepe.out

:loop
if "%1"==""   goto go
if "%1"=="-o" goto outset
if "%1"=="-O" goto outset
if "%1"=="-p" goto f_pset
if "%1"=="-P" goto f_pset
set ~grpopt=%~grpopt% %1
shift
goto loop
:f_pset
set ~grpf_p=1
:outset
set ~grpout=%~grptmp%
if exist %~grpout% del %~grpout%
shift
goto loop

:go
grep -l %~grpopt% AUDIT.EQU	>>%~grpout%
grep -n %~grpopt% AUDIT.EQU	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% BBSEC.EQU	>>%~grpout%
grep -n %~grpopt% BBSEC.EQU	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% DIPSW.EQU	>>%~grpout%
grep -n %~grpopt% DIPSW.EQU	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% DISP.EQU	>>%~grpout%
grep -n %~grpopt% DISP.EQU	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% GAME.EQU	>>%~grpout%
grep -n %~grpopt% GAME.EQU	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% GSP.EQU	>>%~grpout%
grep -n %~grpopt% GSP.EQU	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% LINK.EQU	>>%~grpout%
grep -n %~grpopt% LINK.EQU	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% MENU.EQU	>>%~grpout%
grep -n %~grpopt% MENU.EQU	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% MPROC.EQU	>>%~grpout%
grep -n %~grpopt% MPROC.EQU	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% PLYR.EQU	>>%~grpout%
grep -n %~grpopt% PLYR.EQU	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% SYS.EQU	>>%~grpout%
grep -n %~grpopt% SYS.EQU	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% WORLD.EQU	>>%~grpout%
grep -n %~grpopt% WORLD.EQU	>>%~grpout%

if not "%~grpout%"=="%~grptmp%" goto end
if not exist %~grpout% goto end
if "%~grpf_p%"=="" type %~grpout%
if "%~grpf_p%"=="" goto end
type %~grpout% | more

:end
set ~grpopt=
set ~grpf_p=
set ~grpout=
set ~grptmp=
