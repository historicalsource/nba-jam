@echo off
set ~bblall=0
set ~bblopx=/x

REM Check that environment can handle enough locked flags

set ~bbl=1234567890M
if not "%~bbl%"=="1234567890M" goto ENVERR

REM Check command-line parms

if "%1"==""   goto CHKLOCK
if "%1"=="/x" goto CHKLOCK
if "%1"=="/X" goto CHKLOCK
if "%1"=="-x" goto CHKLOCK
if "%1"=="-X" goto CHKLOCK

echo ERROR -- unknown option "%1". Valid options:
echo.
echo   /X  disable .LOD build-time download to GSP; no effect
echo       when doing .IRW load only; case insensative
goto EXIT

REM Check locked status of LOD files

:CHKLOCK
set ~bbl=
c:
cd \video\bball\img

type BB.LOD    |find "***>"|find ",0"|if not errorlevel 1 set ~bbl=%~bbl%1
type BB2.LOD   |find "***>"|find ",0"|if not errorlevel 1 set ~bbl=%~bbl%2
type BB3.LOD   |find "***>"|find ",0"|if not errorlevel 1 set ~bbl=%~bbl%3
type BB4.LOD   |find "***>"|find ",0"|if not errorlevel 1 set ~bbl=%~bbl%4
type BB5.LOD   |find "***>"|find ",0"|if not errorlevel 1 set ~bbl=%~bbl%5
type BB6.LOD   |find "***>"|find ",0"|if not errorlevel 1 set ~bbl=%~bbl%6
type BB7.LOD   |find "***>"|find ",0"|if not errorlevel 1 set ~bbl=%~bbl%7
type BB8.LOD   |find "***>"|find ",0"|if not errorlevel 1 set ~bbl=%~bbl%8
type BBMUG.LOD |find "***>"|find ",0"|if not errorlevel 1 set ~bbl=%~bbl%9
type BBPAL.LOD |find "***>"|find ",0"|if not errorlevel 1 set ~bbl=%~bbl%0
type MISC.LOD  |find "***>"|find ",0"|if not errorlevel 1 set ~bbl=%~bbl%M

cd ..


:TOP
echo.
echo *****  NBA HANGTIME Image Loader  *****
echo.
if     "%~bbl%"=="" echo 	L -- Load all .IRWs
if not "%~bbl%"=="" echo 	L -- Load all NON-LOCKED .IRWs
                    echo 	B -- Build all .LODs
                    echo.
echo %~bbl%|find >nul "1"
if     errorlevel 1 echo 	  1 -- build BB.LOD
if not errorlevel 1 echo 	  1 -- build BB.LOD    -- LOCKED
echo %~bbl%|find >nul "2"
if     errorlevel 1 echo 	  2 -- build BB2.LOD
if not errorlevel 1 echo 	  2 -- build BB2.LOD   -- LOCKED
echo %~bbl%|find >nul "3"
if     errorlevel 1 echo 	  3 -- build BB3.LOD
if not errorlevel 1 echo 	  3 -- build BB3.LOD   -- LOCKED
echo %~bbl%|find >nul "4"
if     errorlevel 1 echo 	  4 -- build BB4.LOD
if not errorlevel 1 echo 	  4 -- build BB4.LOD   -- LOCKED
echo %~bbl%|find >nul "5"
if     errorlevel 1 echo 	  5 -- build BB5.LOD
if not errorlevel 1 echo 	  5 -- build BB5.LOD   -- LOCKED
echo %~bbl%|find >nul "6"
if     errorlevel 1 echo 	  6 -- build BB6.LOD
if not errorlevel 1 echo 	  6 -- build BB6.LOD   -- LOCKED
echo %~bbl%|find >nul "7"
if     errorlevel 1 echo 	  7 -- build BB7.LOD
if not errorlevel 1 echo 	  7 -- build BB7.LOD   -- LOCKED
echo %~bbl%|find >nul "8"
if     errorlevel 1 echo 	  8 -- build BB8.LOD
if not errorlevel 1 echo 	  8 -- build BB8.LOD   -- LOCKED
echo %~bbl%|find >nul "9"
if     errorlevel 1 echo 	  9 -- build BBMUG.LOD
if not errorlevel 1 echo 	  9 -- build BBMUG.LOD -- LOCKED
echo %~bbl%|find >nul "0"
if     errorlevel 1 echo 	  0 -- build BBPAL.LOD
if not errorlevel 1 echo 	  0 -- build BBPAL.LOD -- LOCKED
echo %~bbl%|find >nul "M"
if     errorlevel 1 echo 	  M -- build MISC.LOD
if not errorlevel 1 echo 	  M -- build MISC.LOD  -- LOCKED
                    echo.
                    echo 	Q -- Quit (or Ctrl-C,Y)
                    echo.
choice /C:LB1234567890MQ /T:Q,30 "Choose wisely! "
echo.

REM Was it Ctrl-C,N?
if not errorlevel 1 goto TOP

REM Was there an error?
if not errorlevel 255 goto CHKOPT
echo Aborting -- can not process ERRORLEVEL
goto EXIT


:CHKOPT
if errorlevel 14 goto EXIT

if not exist ~bbltmp md ~bbltmp

if errorlevel 13 goto DOMISC
if errorlevel 12 goto DOBBPAL
if errorlevel 11 goto DOBBMUG
if errorlevel 10 goto DOBB8
if errorlevel 9  goto DOBB7
if errorlevel 8  goto DOBB6
if errorlevel 7  goto DOBB5
if errorlevel 6  goto DOBB4
if errorlevel 5  goto DOBB3
if errorlevel 4  goto DOBB2
if errorlevel 3  goto DOBB
if errorlevel 2  goto DOALL


:LOADALL
echo %~bbl%|find "1"|if errorlevel 1 load2 BB    /e /ri
echo %~bbl%|find "2"|if errorlevel 1 load2 BB2   /e /ri
echo %~bbl%|find "3"|if errorlevel 1 load2 BB3   /e /ri
echo %~bbl%|find "4"|if errorlevel 1 load2 BB4   /e /ri
echo %~bbl%|find "5"|if errorlevel 1 load2 BB5   /e /ri
echo %~bbl%|find "6"|if errorlevel 1 load2 BB6   /e /ri
echo %~bbl%|find "7"|if errorlevel 1 load2 BB7   /e /ri
echo %~bbl%|find "8"|if errorlevel 1 load2 BB8   /e /ri
echo %~bbl%|find "9"|if errorlevel 1 load2 BBMUG /e /ri
echo %~bbl%|find "M"|if errorlevel 1 load2 MISC  /e /ri
goto END


:DOALL
set ~bblall=1


:DOBB
set ~bblopx=%1
echo %~bbl%|find "1"|if not errorlevel 1 set ~bblopx=/x
load2 BB    /e /di /fi /t=~bbltmp %~bblopx%
del  >nul ~bbltmp\imgtbl.asm
ren  >nul ~bbltmp\imgtbl.glo imgtbl1.glo
ren  >nul ~bbltmp\imgpal.asm imgpal1.asm
move >nul /Y ~bbltmp\*.* .
if "%~bblall%"=="0" goto END


:DOBB2
set ~bblopx=%1
echo %~bbl%|find "2"|if not errorlevel 1 set ~bblopx=/x
load2 BB2   /e /di /fi /t=~bbltmp %~bblopx%
del  >nul ~bbltmp\imgtbl.asm
ren  >nul ~bbltmp\imgtbl.glo imgtbl2.glo
ren  >nul ~bbltmp\imgpal.asm imgpal2.asm
move >nul /Y ~bbltmp\*.* .
if "%~bblall%"=="0" goto END


:DOBB3
set ~bblopx=%1
echo %~bbl%|find "3"|if not errorlevel 1 set ~bblopx=/x
load2 BB3   /e /di /fi /t=~bbltmp %~bblopx%
del  >nul ~bbltmp\imgtbl.asm
del  >nul ~bbltmp\imgtbl.glo
ren  >nul ~bbltmp\imgpal.asm imgpal3.asm
move >nul /Y ~bbltmp\*.* .
if "%~bblall%"=="0" goto END


:DOBB4
set ~bblopx=%1
echo %~bbl%|find "4"|if not errorlevel 1 set ~bblopx=/x
load2 BB4   /e /di /fi /t=~bbltmp %~bblopx%
del  >nul ~bbltmp\imgtbl.asm
del  >nul ~bbltmp\imgtbl.glo
ren  >nul ~bbltmp\imgpal.asm imgpal4.asm
move >nul /Y ~bbltmp\*.* .
if "%~bblall%"=="0" goto END


:DOBB5
set ~bblopx=%1
echo %~bbl%|find "5"|if not errorlevel 1 set ~bblopx=/x
load2 BB5   /e /di /fi /t=~bbltmp %~bblopx%
del  >nul ~bbltmp\imgtbl.asm
del  >nul ~bbltmp\imgtbl.glo
ren  >nul ~bbltmp\imgpal.asm imgpal5.asm
move >nul /Y ~bbltmp\*.* .
if "%~bblall%"=="0" goto END


:DOBB6
set ~bblopx=%1
echo %~bbl%|find "6"|if not errorlevel 1 set ~bblopx=/x
load2 BB6   /e /di /fi /t=~bbltmp %~bblopx%
del  >nul ~bbltmp\imgtbl.asm
del  >nul ~bbltmp\imgtbl.glo
ren  >nul ~bbltmp\imgpal.asm imgpal6.asm
move >nul /Y ~bbltmp\*.* .
if "%~bblall%"=="0" goto END


:DOBB7
set ~bblopx=%1
echo %~bbl%|find "7"|if not errorlevel 1 set ~bblopx=/x
load2 BB7   /e /di /fi /t=~bbltmp %~bblopx%
del  >nul ~bbltmp\imgtbl.asm
ren  >nul ~bbltmp\bgndpal.asm bgndpal7.asm
ren  >nul ~bbltmp\bgndtbl.asm bgndtbl7.asm
ren  >nul ~bbltmp\bgndtbl.glo bgndtbl7.glo
ren  >nul ~bbltmp\bgndequ.h   bgndequ7.h
ren  >nul ~bbltmp\imgtbl.glo imgtbl7.glo
ren  >nul ~bbltmp\imgpal.asm imgpal7.asm
move >nul /Y ~bbltmp\*.* .
if "%~bblall%"=="0" goto END


:DOBB8
set ~bblopx=%1
echo %~bbl%|find "8"|if not errorlevel 1 set ~bblopx=/x
load2 BB8   /e /di /fi /t=~bbltmp %~bblopx%
del  >nul ~bbltmp\imgtbl.asm
del  >nul ~bbltmp\imgtbl.glo
ren  >nul ~bbltmp\imgpal.asm imgpal8.asm
move >nul /Y ~bbltmp\*.* .
if "%~bblall%"=="0" goto END


:DOBBMUG
set ~bblopx=%1
echo %~bbl%|find "9"|if not errorlevel 1 set ~bblopx=/x
load2 BBMUG /e /di /fi /t=~bbltmp %~bblopx%
del  >nul ~bbltmp\imgtbl.asm
ren  >nul ~bbltmp\imgtbl.glo imgtblm.glo
ren  >nul ~bbltmp\imgpal.asm imgpalm.asm
move >nul /Y ~bbltmp\*.* .
if "%~bblall%"=="0" goto END


:DOBBPAL
set ~bblopx=%1
echo %~bbl%|find "0"|if not errorlevel 1 set ~bblopx=/x
load2 BBPAL /e /di /t=~bbltmp %~bblopx%
del  >nul ~bbltmp\imgtbl.asm
ren  >nul ~bbltmp\imgtbl.glo imgtblp.glo
ren  >nul ~bbltmp\imgpal.asm imgpalp.asm
move >nul /Y ~bbltmp\*.* .
if "%~bblall%"=="0" goto END


:DOMISC
set ~bblopx=%1
echo %~bbl%|find "M"|if not errorlevel 1 set ~bblopx=/x
load2 MISC  /e /di /fi /tc %~bblopx%
if "%~bblall%"=="0" goto END


goto END


:ENVERR
echo ERROR -- insufficient DOS environment space
goto EXIT


:END
rd ~bbltmp
if exist junkxxxx.* del junkxxxx.*
if exist l2temp     del l2temp
if exist *.~sm      del *.~sm
if exist *.~bl      del *.~bl
echo.
echo Done.


:EXIT
set ~bblall=
set ~bblopx=
set ~bbl=

echo.
