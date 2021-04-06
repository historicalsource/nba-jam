@echo off
if "%1"==""  goto END
if "%1"=="*" goto ERR
if exist %1.asm goto SETUP
echo ERROR: file "%1.asm" not found
goto END

:SETUP
echo >pcl\tmp
if not exist pcl\tmp md  pcl
if     exist pcl\tmp del pcl\tmp

grep -v -e ";DJT" -v -e ";MJT" -v -e ";JBJ" -v -e ";SL;" %1.asm > %1.cln
diff %1.asm     %1.cln
move %1.asm pcl\%1.pca
ren  %1.cln     %1.asm
goto END

:ERR
echo ERROR: filename wildcards are not supported

:END
