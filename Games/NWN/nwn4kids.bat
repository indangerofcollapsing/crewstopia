@echo off
cd %NWN_HOME%
if exist portraits ren portraits portraits.not
if exist modules ren modules modules.not
nwmain.exe
