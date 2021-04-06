@echo off
if "%winpmt%"=="" set winpmt=%prompt%
set prompt=WIMP-Win %winpmt%
cd img
ds en
newwimp /col=0x0008,0x7fff /u=z
exit
