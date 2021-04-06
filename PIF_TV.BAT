@echo off
if "%winpmt%"=="" set winpmt=%prompt%
set prompt=TV-Win %winpmt%

:TOP
echo.
echo ToddView Batch
echo ==============
echo  L)oad only
echo  W)arm start
echo  eX)it
choice /C:LWX "Select "
echo.

REM Was it Ctrl-C,N?
if not errorlevel 1 goto TOP

REM Was there an error?
if not errorlevel 255 goto CHKOPT
echo.
echo Aborting -- can not process ERRORLEVEL
echo.
goto END

:CHKOPT
if errorlevel 3 goto END
if errorlevel 2 goto WARM

tv bb /v
goto TOP

:WARM
tv bb /v /w
goto TOP

:END
exit
