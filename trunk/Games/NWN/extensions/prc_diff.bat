@echo off
echo %0 %*
set filename=%~n1%~x1
echo Finding %filename% in %NWN_HOME_PRC%
for /F "usebackq" %%g in (`dir /b /s %NWN_HOME_PRC%\src\%filename%`) do tortoisemerge /mine:%1 /base:%%g
