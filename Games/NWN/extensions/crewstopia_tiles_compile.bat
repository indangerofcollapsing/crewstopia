@echo off
REM echo [debug] %0 %*
setlocal
set HAK_NAME=Crewstopia_tiles
echo Creating temp directory for %HAK_NAME%...
if exist %NWN_HOME%\hak\%HAK_NAME%\. rmdir /s /q %NWN_HOME%\hak\%HAK_NAME%
mkdir %NWN_HOME%\hak\%HAK_NAME%
if not exist %NWN_HOME%\hak\%HAK_NAME%\. goto end
cd %NWN_HOME%\hak\%HAK_NAME%
mkdir 2da
xcopy %NWN_HOME_CEP%\src\2da\genericdoors.2da .\2da\.
xcopy %NWN_HOME_CEP%\src\2da\loadscreens.2da .\2da\.
xcopy %NWN_HOME_CEP%\src\2da\portraits.2da .\2da\.
xcopy %NWN_HOME_CEP%\src\2da\soundset.2da .\2da\.

REM Export and merge component haks
echo Exporting component haks...
call :exportHak Aztec_exterior.hak
call :exportHak BMMountainsv102.hak
call :exportHak CityExpandedv3.hak
call :exportHak codi_sigil_ext.hak
call :exportHak codi_sigil_int.hak
call :exportHak crpcity.hak
call :exportHak crpdungeons.hak
call :exportHak crprural.hak
call :exportHak crpwilderness.hak
call :exportHak ctp_brick_int.hak
call :exportHak ctp_cave_ruins.hak
call :exportHak ctp_dungeon_lok.hak
call :exportHak ctp_dwarf_hall.hak
call :exportHak ctp_exp_elf_city.hak
call :exportHak ctp_goth_estate.hak
call :exportHak ctp_goth_int.hak
call :exportHak ctpr_dungeon.hak
call :exportHak ctp_genericdoors.hak
call :exportHak ctp_common.hak
call :exportHak drw.hak
call :exportHak egyptian.hak
call :exportHak Full_ForestRural.hak
call :exportHak swamp.hak
call :exportHak sx_space_tileset.hak
call :exportHak Undersea.hak

REM Build the hak file
echo Building %HAK_NAME%.hak...
cd %NWN_HOME%\hak
if exist %HAK_NAME%.hak.bak del %HAK_NAME%.hak.bak
if exist %HAK_NAME%.hak ren %HAK_NAME%.hak %HAK_NAME%.hak.bak
cd %NWN_HOME%\hak\%HAK_NAME%
erf -c %NWN_HOME%\hak\%HAK_NAME%.hak *.* | goto end
echo Success.

goto end

:exportHak
REM echo [debug] %0 %*
echo Exporting %1...
mkdir %NWN_HOME%\hak\%HAK_NAME%\%1
cd %NWN_HOME%\hak\%HAK_NAME%\%1
call erf -x %NWN_HOME%\hak\%1
echo Merging %1...
for %%f in (*.ini *.2da) do call :mergeFile %1 %%f
echo Moving files...
move *.* %NWN_HOME%\hak\%HAK_NAME%\. >NUL
cd %NWN_HOME%\hak\%HAK_NAME%
echo Deleting temp directory...
rmdir %1
goto :EOF

:mergeFile
REM echo [debug] %0 %*
REM echo Looking for %NWN_HOME%\hak\%HAK_NAME%\%2
REM if not exist %NWN_HOME%\hak\%HAK_NAME%\2da\%2 goto mergeMoveFile
REM echo %NWN_HOME%\hak\%HAK_NAME%\2da\%2 found.
REM tortoisemerge /mine:%NWN_HOME%\hak\%HAK_NAME%\2da\%2 /base:%NWN_HOME%\hak\%HAK_NAME%\%1\%2
copy %NWN_HOME%\hak\%HAK_NAME%\%2 %NWN_HOME%\hak\%HAK_NAME%\2da\%1.%2
goto mergeDone
:mergeMoveFile
REM echo %NWN_HOME%\hak\%HAK_NAME%\2da\%2 not found.
REM move %NWN_HOME%\hak\%HAK_NAME%\%1\%2 %NWN_HOME%\hak\%HAK_NAME%\.
REM goto mergeDone
:mergeDone
goto :EOF

:end
endlocal
