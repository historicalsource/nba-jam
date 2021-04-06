@echo off
set ~bbcp=attrib123

if .%1.==./d. set ~bbcp=del
if .%1.==./D. set ~bbcp=del
if .%1.==.-d. set ~bbcp=del
if .%1.==.-D. set ~bbcp=del

if .%~bbcp%.==.attrib123. goto PROC
if .%~bbcp%.==.del.       goto PROC

echo ERROR -- insufficient DOS environment space
echo.
goto EXIT


:PROC
if .%~bbcp%.==.attrib123. set ~bbcp=attrib -a

if exist c:\video\bball\imgpal*.asm %~bbcp% c:\video\bball\imgpal*.asm
if exist c:\video\bball\imgtbl*.asm %~bbcp% c:\video\bball\imgtbl*.asm
if exist c:\video\bball\bgnd*.asm   %~bbcp% c:\video\bball\bgnd*.asm
if exist c:\video\bball\*.h         %~bbcp% c:\video\bball\*.h
if exist c:\video\bball\*.obj       %~bbcp% c:\video\bball\*.obj
if exist c:\video\bball\*.lst       %~bbcp% c:\video\bball\*.lst
if exist c:\video\bball\*.glo       %~bbcp% c:\video\bball\*.glo
if exist c:\video\bball\*.tbl       %~bbcp% c:\video\bball\*.tbl


:EXIT
if exist c:\video\bball\mc*.  del c:\video\bball\mc*.
if exist c:\video\bball\*.axx del c:\video\bball\*.axx

ds en c:\video\bball

set ~bbcp=
