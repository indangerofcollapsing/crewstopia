@echo off
cd %NWN_HOME%
if exist portraits.not ren portraits.not portraits
if exist modules.not ren modules.not modules
nwmain.exe +connect localhost
