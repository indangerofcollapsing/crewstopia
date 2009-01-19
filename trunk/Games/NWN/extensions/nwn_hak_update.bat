@echo off
@echo %0 %*
setlocal
cd %NWN_HOME%\extensions
set logfile=%NWN_HOME%\extensions\nwn_hak_update.log
if exist %logfile% del %logfile%
echo %DATE% %TIME% >%logfile%

REM dac_Override.hak
cd %NWN_HOME%\hak
copy /y dac_Override.hak dac_Override.hak.bak
copy /y _blank.hak dac_Override.hak
set tempHOME=%NWN_HOME%\extensions\Custom\Override
cd %tempHOME%
for /D %%d in (*) do call :compileAndUpdateHak %%d dac_Override.hak

REM dac_Palette.hak
cd %NWN_HOME%\hak
copy /y dac_Palette.hak dac_Palette.hak.bak
copy /y _blank.hak dac_Palette.hak
set tempHOME=%NWN_HOME%\extensions\Custom\Palette
cd %tempHOME%
for /D %%d in (*) do call :compileAndUpdateHak %%d dac_Palette.hak

REM dac_PersistWorld.hak
cd %NWN_HOME%\hak
copy /y dac_PersistWorld.hak dac_PersistWorld.hak.bak
copy /y _blank.hak dac_PersistWorld.hak
set tempHOME=%NWN_HOME%\extensions\Custom\PersistentWorld
cd %tempHOME%
for /D %%d in (*) do call :compileAndUpdateHak %%d dac_PersistWorld.hak

REM dac_prc.hak
cd %NWN_HOME%\hak
copy /y dac_prc.hak dac_prc.hak.bak
copy /y _blank.hak dac_prc.hak
set tempHOME=%NWN_HOME%\extensions\Custom\Palette
cd %tempHOME%
call :compileAndUpdateHak Dialogs dac_prc.hak
call :compileAndUpdateHak ItemEnhance dac_prc.hak
call :compileAndUpdateHak Items dac_prc.hak
call :compileAndUpdateHak Merchants dac_prc.hak
call :compileAndUpdateHak MKCraftingDialog dac_prc.hak
call :compileAndUpdateHak OHS_Henchmen dac_prc.hak
call :compileAndUpdateHak scripts dac_prc.hak
set tempHOME=%NWN_HOME%\extensions\Custom\Override
cd %tempHOME%
for /D %%d in (*) do call :compileAndUpdateHak %%d dac_prc.hak

REM dac.erf
cd %NWN_HOME%\erf
copy /y dac.erf dac.erf.bak
copy /y _blank.erf dac.erf
set tempHOME=%NWN_HOME%\extensions\Custom\erf
cd %tempHOME%
call nwnc *.nss
call erf.bat -u %NWN_HOME%\erf\dac.erf *.* | tee -a %logfile%
del *.ncs

REM _debug
REM set tempHOME=%NWN_HOME%\extensions\Custom\Testing
REM cd %tempHOME%
REM for /D %%d in (*) do call :compileAndUpdateHak %%d _debug.hak
goto end

:compileAndUpdateHak
echo %0 %* | tee -a %logfile%
if "%1" == ".svn" goto :EOF
cd %tempHOME%\%1
if exist *.ncs del *.ncs
if exist *.nss call nwnc.bat *.nss >>%logfile% | goto end
if not ERRORLEVEL 0 goto end
if exist *.2da call erf.bat -u %NWN_HOME%\hak\%2 *.2da | tee -a %logfile%
if exist *.n?s call erf.bat -u %NWN_HOME%\hak\%2 *.n?s | tee -a %logfile%
if exist *.ut? call erf.bat -u %NWN_HOME%\hak\%2 *.ut? | tee -a %logfile%
if exist *.dlg call erf.bat -u %NWN_HOME%\hak\%2 *.dlg | tee -a %logfile%
if exist *.tga call erf.bat -u %NWN_HOME%\hak\%2 *.tga | tee -a %logfile%
if exist *.mdl call erf.bat -u %NWN_HOME%\hak\%2 *.mdl | tee -a %logfile%
if exist *.dds call erf.bat -u %NWN_HOME%\hak\%2 *.dds | tee -a %logfile%
if exist *.dwk call erf.bat -u %NWN_HOME%\hak\%2 *.dwk | tee -a %logfile%
if exist *.wav call erf.bat -u %NWN_HOME%\hak\%2 *.wav | tee -a %logfile%
if exist *.ssf call erf.bat -u %NWN_HOME%\hak\%2 *.ssf | tee -a %logfile%
if exist *.ncs del *.ncs
if exist *.bak del *.bak
cd %tempHOME%
goto :EOF

:end
cd %NWN_HOME%\extensions
if exist %logfile% call notepad %logfile%
endlocal
