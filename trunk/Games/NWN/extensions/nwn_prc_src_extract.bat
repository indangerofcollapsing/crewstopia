@echo off
if not exist prc_2das.hak goto wrongDir
setlocal
set CURRDIR=%CD%
if not exist src\* mkdir src
cd src
attrib -R *.* /s
if not exist 2da\* mkdir 2da
cd 2da
call erf.bat -x %CURRDIR%\prc_2das.hak
cd ..
if not exist epicspells\* mkdir epicspells
cd epicspells
call erf.bat -x %CURRDIR%\prc_epicspells.hak
cd ..
if not exist include\* mkdir include
cd include
call erf.bat -x %CURRDIR%\prc_include.hak
cd ..
if not exist newspellbook\* mkdir newspellbook
cd newspellbook
call erf.bat -x %CURRDIR%\prc_newspellbook.hak
cd ..
if not exist psionics\* mkdir psionics
cd psionics
call erf.bat -x %CURRDIR%\prc_psionics.hak
cd ..
if not exist race\* mkdir race
cd race
call erf.bat -x %CURRDIR%\prc_race.hak
cd ..
if not exist scripts\* mkdir scripts
cd scripts
call erf.bat -x %CURRDIR%\prc_scripts.hak
cd ..
if not exist spells\* mkdir spells
cd spells
call erf.bat -x %CURRDIR%\prc_spells.hak
cd ..
del /s *.dlg *.ncs *.ut?
attrib +R *.* /s
goto end

:wrongDir
echo Are you sure you're in the right directory?
goto end

:end
endlocal
