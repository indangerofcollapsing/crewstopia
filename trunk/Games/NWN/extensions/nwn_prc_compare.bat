@echo off
set lastDir=%CD%
if "%1" == "" goto compareAll

:compareOne
call :findIt %1
goto end

:compareAll
set MINE=%NWN_HOME%\extensions\Custom\Override
for /F "usebackq" %%f in (`dir /b /s %MINE%\*.2da`) do call :findIt %%f
for /F "usebackq" %%f in (`dir /b /s %MINE%\*.nss`) do call :findIt %%f

set MINE=%NWN_HOME%\extensions\Custom\erf
for /F "usebackq" %%f in (`dir /b /s %MINE%\*.nss`) do call :findIt %%f

goto end

:findIt
echo %0 %*
set filename=%~n1%~x1
echo Finding %filename%
for /F "usebackq" %%g in (`dir /b /s %NWN_HOME_PRC%\src\%filename%`) do call :diffIt %1 %%g 2>NUL
goto :EOF

:diffIt
fc %1 %2 >NUL
if ERRORLEVEL 1 tortoisemerge /mine:%1 /base:%2
goto :EOF

:end
cd %lastDir%
