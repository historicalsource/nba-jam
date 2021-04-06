@echo off
set ~grpopt=
set ~grpf_p=
set ~grpout=con
set ~grptmp=grepa.out

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
grep -l %~grpopt% ADJUST.ASM	>>%~grpout%
grep -n %~grpopt% ADJUST.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% ATTRACT.ASM	>>%~grpout%
grep -n %~grpopt% ATTRACT.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% AUDIT.ASM	>>%~grpout%
grep -n %~grpopt% AUDIT.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% BAKGND.ASM	>>%~grpout%
grep -n %~grpopt% BAKGND.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% BB.ASM	>>%~grpout%
grep -n %~grpopt% BB.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% BB2.ASM	>>%~grpout%
grep -n %~grpopt% BB2.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% DIAG.ASM	>>%~grpout%
grep -n %~grpopt% DIAG.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% DRONE.ASM	>>%~grpout%
grep -n %~grpopt% DRONE.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% DRONE2.ASM	>>%~grpout%
grep -n %~grpopt% DRONE2.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% HSTD.ASM	>>%~grpout%
grep -n %~grpopt% HSTD.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% MAIN.ASM	>>%~grpout%
grep -n %~grpopt% MAIN.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% MAKEPLR.ASM	>>%~grpout%
grep -n %~grpopt% MAKEPLR.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% MAKEPLR2.ASM	>>%~grpout%
grep -n %~grpopt% MAKEPLR2.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% MENU.ASM	>>%~grpout%
grep -n %~grpopt% MENU.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% MPROC.ASM	>>%~grpout%
grep -n %~grpopt% MPROC.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% NDSP1.ASM	>>%~grpout%
grep -n %~grpopt% NDSP1.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% PAL.ASM	>>%~grpout%
grep -n %~grpopt% PAL.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% PATCH.ASM	>>%~grpout%
grep -n %~grpopt% PATCH.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% PLYR.ASM	>>%~grpout%
grep -n %~grpopt% PLYR.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% PLYR2.ASM	>>%~grpout%
grep -n %~grpopt% PLYR2.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% PLYR3.ASM	>>%~grpout%
grep -n %~grpopt% PLYR3.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% PLYRAT.ASM	>>%~grpout%
grep -n %~grpopt% PLYRAT.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% PLYRAT2.ASM	>>%~grpout%
grep -n %~grpopt% PLYRAT2.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% PLYRDSEQ.ASM	>>%~grpout%
grep -n %~grpopt% PLYRDSEQ.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% PLYRLSEQ.ASM	>>%~grpout%
grep -n %~grpopt% PLYRLSEQ.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% PLYRSEQ.ASM	>>%~grpout%
grep -n %~grpopt% PLYRSEQ.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% PLYRSEQ2.ASM	>>%~grpout%
grep -n %~grpopt% PLYRSEQ2.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% PLYRSTND.ASM	>>%~grpout%
grep -n %~grpopt% PLYRSTND.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% RECORD.ASM	>>%~grpout%
grep -n %~grpopt% RECORD.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% SCORE.ASM	>>%~grpout%
grep -n %~grpopt% SCORE.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% SCORE2.ASM	>>%~grpout%
grep -n %~grpopt% SCORE2.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% SCREEN.ASM	>>%~grpout%
grep -n %~grpopt% SCREEN.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% SELECT.ASM	>>%~grpout%
grep -n %~grpopt% SELECT.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% SELECT2.ASM	>>%~grpout%
grep -n %~grpopt% SELECT2.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% SELECT3.ASM	>>%~grpout%
grep -n %~grpopt% SELECT3.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% SOUNDS.ASM	>>%~grpout%
grep -n %~grpopt% SOUNDS.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% SPEECH.ASM	>>%~grpout%
grep -n %~grpopt% SPEECH.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% STRING.ASM	>>%~grpout%
grep -n %~grpopt% STRING.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% TEST.ASM	>>%~grpout%
grep -n %~grpopt% TEST.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% TEXT.ASM	>>%~grpout%
grep -n %~grpopt% TEXT.ASM	>>%~grpout%
if not errorlevel 1 echo.>>%~grpout%
grep -l %~grpopt% UTIL.ASM	>>%~grpout%
grep -n %~grpopt% UTIL.ASM	>>%~grpout%

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
