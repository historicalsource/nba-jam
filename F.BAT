@echo off
set ~~cmp=s:
set ~~cpy=g:
set ~~ext=.asm

if not "%1"=="" goto setup
echo F-- File compare & merge v10.03.95 --by Dan Thompson
echo Copyright (C) 1995 Williams Electronics
echo.
echo Environment variables to set for the compare:
echo   FCMP = (d:) to compare current (d:) to ("%~~cmp%" if not specified)
echo   FCPY = (d:) to copy merged files to    ("%~~cpy%" if not specified)
echo   FEXT = current file extension          ("%~~ext%" if not specified)
echo.
goto end

:setup
if not "%FCMP%"=="" set ~~cmp=%FCMP%
if not "%FCPY%"=="" set ~~cpy=%FCPY%
if not "%FEXT%"=="" set ~~ext=%FEXT%

if not exist        %1%~~ext% goto error
if not exist %~~cmp%%1%~~ext% goto error

fc %1%~~ext% %~~cmp%%1%~~ext% >diffy
type diffy

choice /c:cdbx Copy c: or Dupe %~~cmp% to %~~cpy%, enter Brief, or eXit 
if errorlevel 4 goto end
if errorlevel 3 goto brief
if errorlevel 2 goto next
copy /b %1%~~ext% %~~cpy% /v
goto end

:next
copy /b %~~cmp%%1%~~ext% %~~cpy% /v
goto end

:brief
b diffy %1%~~ext% %~~cmp%%1%~~ext%
goto end

:error
echo Bite me! Go find your stupid files to compare.
echo.

:end
set ~~cmp=
set ~~cpy=
set ~~ext=
