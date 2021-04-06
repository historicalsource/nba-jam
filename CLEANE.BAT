@echo off
if "%1"==""  goto END
if "%1"=="*" goto ERR
if exist %1.equ goto SETUP
echo ERROR: file "%1.equ" not found
goto END

:SETUP
echo >pcl\tmp
if not exist pcl\tmp md  pcl
if     exist pcl\tmp del pcl\tmp

grep -v -e ";DJT" -v -e ";MJT" -v -e ";JBJ" -v -e ";SL;" %1.equ > %1.cln
diff %1.equ     %1.cln
move %1.equ pcl\%1.pce
ren  %1.cln     %1.equ
goto END

:ERR
echo ERROR: filename wildcards are not supported

:END
