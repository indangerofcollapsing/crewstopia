REM @echo off
if not exist prc_2das.hak goto err
setlocal
set NWN_HOME_PRC=%CD%
if exist %NWN_HOME%\extensions\nwnc.log del %NWN_HOME%\extensions\nwnc.log
if exist %NWN_HOME%\extensions\nwnc.err del %NWN_HOME%\extensions\nwnc.err
cd src\epicspells
call nwnc *.nss >> %NWN_HOME%\extensions\nwnc.log 2> %NWN_HOME%\extensions\nwnc.err
if not ERRORLEVEL 0 goto end
call erf.bat -u ..\..\prc_epicspells.hak *.ncs
if not ERRORLEVEL 0 goto end
cd ..\newspellbook
call nwnc *.nss >> %NWN_HOME%\extensions\nwnc.log 2> %NWN_HOME%\extensions\nwnc.err
if not ERRORLEVEL 0 goto end
call erf.bat -u ..\..\prc_newspellbook.hak *.ncs
if not ERRORLEVEL 0 goto end
cd ..\psionics
call nwnc *.nss >> %NWN_HOME%\extensions\nwnc.log 2> %NWN_HOME%\extensions\nwnc.err
if not ERRORLEVEL 0 goto end
call erf.bat -u ..\..\prc_psionics.hak *.ncs
if not ERRORLEVEL 0 goto end
cd ..\race
call nwnc *.nss >> %NWN_HOME%\extensions\nwnc.log 2> %NWN_HOME%\extensions\nwnc.err
if not ERRORLEVEL 0 goto end
call erf.bat -u ..\..\prc_race.hak *.ncs
if not ERRORLEVEL 0 goto end
cd ..\scripts
call nwnc *.nss >> %NWN_HOME%\extensions\nwnc.log 2> %NWN_HOME%\extensions\nwnc.err
if not ERRORLEVEL 0 goto end
call erf.bat -u ..\..\prc_scripts.hak *.ncs
if not ERRORLEVEL 0 goto end
cd ..\spells
call nwnc *.nss >> %NWN_HOME%\extensions\nwnc.log 2> %NWN_HOME%\extensions\nwnc.err
if not ERRORLEVEL 0 goto end
call erf.bat -u ..\..\prc_spells.hak *.ncs
if not ERRORLEVEL 0 goto end
cd ..
del /s *.ncs
cd ..
notepad %NWN_HOME%\extensions\nwnc.log %NWN_HOME%\extensions\nwnc.err
goto end

:err
echo Can't find prc_2das.hak.  Can't continue.
goto end

:end
endlocal
