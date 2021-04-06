@echo off
c:\qemm\vidram /on
c:
cd \video\bball
make %1 %2 %3 %4 %5 %6 
c:\qemm\vidram /off
bb
run

