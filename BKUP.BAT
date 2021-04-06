@echo off
if not "%1"=="/?" goto CHECK
echo BKUP will back-up to I: all files with the Archive
echo attribute set. Use the /A option to ignore the
echo attribute and back-up all files.
echo.
goto END

:CHECK
echo >i:\~bktest
if exist i:\~bktest goto DO
echo You should probably log-on to the net first.
echo.
goto END

:DO
set ~bka=/m
if "%1"=="/a" set ~bka=
if "%1"=="/A" set ~bka=
i:
if not exist c:\video\doc\*.* goto NEXT

echo Backing up DOC directory...
cd \video\doc
cd c:\video\doc
xcopy c:*.* /v %~bka%
echo Backing up basketball...

:NEXT
cd \video\bball
cd c:\video\bball
xcopy c:makefile /v %~bka%
xcopy c:_marker_ /v %~bka%
xcopy c:*.asm    /v %~bka%
xcopy c:*.bat    /v %~bka%
xcopy c:*.cmd    /v %~bka%
xcopy c:*.doc    /v %~bka%
xcopy c:*.equ    /v %~bka%
xcopy c:*.hdr    /v %~bka%
xcopy c:*.ini    /v %~bka%
xcopy c:*.tv     /v %~bka%
xcopy c:*.tvs    /v %~bka%

cd img
cd c:img
xcopy c:_marker_ /v %~bka%
xcopy c:*.bdb    /v %~bka%
xcopy c:*.bdd    /v %~bka%
xcopy c:*.bin    /v %~bka%
xcopy c:*.img    /v %~bka%
xcopy c:*.ini    /v %~bka%
xcopy c:*.lod    /v %~bka%
c:
cd ..

:END
if exist i:\~bktest del i:\~bktest

set ~bka=
