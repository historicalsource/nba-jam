@echo off
if "%winpmt%"=="" set winpmt=%prompt%
set prompt=BLIMP-Win %winpmt%
cd img
ds en
blimp /out=logblimp.out
exit
