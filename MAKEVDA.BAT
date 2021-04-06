@echo off
cd c:\video\bball\img

if exist cheers.* del cheers.*
if exist trophy.* del trophy.*

vda2frm cheers
vda2frm trophy
pkzipo cheers cheers.frm
pkzipo trophy trophy.frm
zip2bin cheers
zip2bin trophy

load2 BBVDA /di /fi /ti /x
del >nul imgtbl.asm
del >nul imgtbl.glo
del >nul imgpal.asm
move >nul /Y *.tbl ..

if exist cheers.frm del cheers.frm
if exist cheers.hdr del cheers.hdr
if exist cheers.zip del cheers.zip
if exist trophy.frm del trophy.frm
if exist trophy.hdr del trophy.hdr
if exist trophy.zip del trophy.zip

cd ..
