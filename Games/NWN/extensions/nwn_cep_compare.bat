@echo off
set CEP=%CD%
if exist .\src\. goto cepVersionSet
set CEP=%NWN_HOME%\extensions\CEP2.2
:cepVersionSet

set MINE=%NWN_HOME%\extensions\Custom\Palette
for /F "usebackq" %%f in (`dir /b /s %MINE%\*.2da`) do call :findIt %%f
for /F "usebackq" %%f in (`dir /b /s %MINE%\*.nss`) do call :findIt %%f

set MINE=%NWN_HOME%\extensions\Custom\Override
for /F "usebackq" %%f in (`dir /b /s %MINE%\*.2da`) do call :findIt %%f
for /F "usebackq" %%f in (`dir /b /s %MINE%\*.nss`) do call :findIt %%f

set MINE=%NWN_HOME%\extensions\Custom\erf
for /F "usebackq" %%f in (`dir /b /s %MINE%\*.nss`) do call :findIt %%f

goto end

:findIt
REM echo %0 %*
set filename=%~n1%~x1
REM echo Finding %filename%
for /F "usebackq" %%g in (`dir /b /s %CEP%\src\%filename%`) do call :diffIt %1 %%g 2>NUL
goto :EOF

:diffIt
fc %1 %2
if ERRORLEVEL 1 tortoisemerge /mine:%1 /base:%2
goto :EOF

:end
