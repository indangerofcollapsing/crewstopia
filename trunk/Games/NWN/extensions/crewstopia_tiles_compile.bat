@echo off
REM echo [debug] %0 %*
setlocal
set HAK_NAME=Crewstopia_tiles
echo Creating temp directory for %HAK_NAME%...
if exist %NWN_HOME%\hak\%HAK_NAME%\. rmdir /s /q %NWN_HOME%\hak\%HAK_NAME%
mkdir %NWN_HOME%\hak\%HAK_NAME%
if not exist %NWN_HOME%\hak\%HAK_NAME%\. goto end
mkdir %NWN_HOME%\hak\%HAK_NAME%\2da

REM Export and merge component haks
echo Exporting component haks...
call :exportHak Aztec_exterior.hak
call :exportHak BMMountainsv102.hak
call :exportHak CityExpandedv3.hak
call :exportHak codi_sigil_ext.hak
call :exportHak codi_sigil_int.hak
call :exportHak drw.hak
call :exportHak egyptian.hak
call :exportHak Full_ForestRural.hak
call :exportHak IceMines.hak
call :exportHak swamp.hak
call :exportHak sx_space_tileset.hak
call :exportHak Undersea.hak

REM Build the Crewstopia_tile1.hak file
echo Building Crewstopia_tile1.hak...
cd %NWN_HOME%\hak\%HAK_NAME%
xcopy /y %NWN_HOME_CEP%\src\2da\genericdoors.2da .
xcopy /y %NWN_HOME_CEP%\src\2da\loadscreens.2da .
xcopy /y %NWN_HOME_CEP%\src\2da\soundset.2da .
xcopy /y %NWN_HOME%\extensions\Custom\Override\Tilesets\*.* .
cd %NWN_HOME%\hak
if exist Crewstopia_tile1.hak.bak del Crewstopia_tile1.hak.bak
if exist Crewstopia_tile1.hak ren Crewstopia_tile1.hak Crewstopia_tile1.hak.bak
cd %NWN_HOME%\hak\%HAK_NAME%
erf -c %NWN_HOME%\hak\Crewstopia_tile1.hak *.* | goto end
echo Success.

if exist %NWN_HOME%\hak\%HAK_NAME%\. rmdir /s /q %NWN_HOME%\hak\%HAK_NAME%
mkdir %NWN_HOME%\hak\%HAK_NAME%
if not exist %NWN_HOME%\hak\%HAK_NAME%\. goto end
mkdir %NWN_HOME%\hak\%HAK_NAME%\2da

REM Export and merge component haks
call :exportHak crpcity.hak
call :exportHak crpdungeons.hak
call :exportHak crprural.hak
call :exportHak crpwilderness.hak
call :exportHak ctpr_dungeon.hak
call :exportHak ctp_brick_int.hak
call :exportHak ctp_cave_ruins.hak
call :exportHak ctp_dungeon_lok.hak
call :exportHak ctp_goth_estate.hak
call :exportHak ctp_goth_int.hak
call :exportHak ctp_exp_elf_city.hak
call :exportHak ctp_dwarf_hall.hak
call :exportHak ctp_genericdoors.hak
call :exportHak ctp_common.hak
call :exportHak ctp_bio_fix.hak

REM Build the Crewstopia_tile2.hak file
echo Building Crewstopia_tile2.hak...
REM cd %NWN_HOME%\hak\%HAK_NAME%
cd %NWN_HOME%\hak
if exist Crewstopia_tile2.hak.bak del Crewstopia_tile2.hak.bak
if exist Crewstopia_tile2.hak ren Crewstopia_tile2.hak Crewstopia_tile2.hak.bak
REM if exist Crewstopia_tile2.hak copy Crewstopia_tile2.hak Crewstopia_tile2.hak.bak
cd %NWN_HOME%\hak\%HAK_NAME%
erf -c %NWN_HOME%\hak\Crewstopia_tile2.hak *.* | goto end
REM erf -u %NWN_HOME%\hak\Crewstopia_tile2.hak *.* | goto end
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
echo Looking for %NWN_HOME%\hak\%HAK_NAME%\%2
if not exist %NWN_HOME%\hak\%HAK_NAME%\2da\%2 goto mergeMoveFile
echo %NWN_HOME%\hak\%HAK_NAME%\2da\%2 found.
REM tortoisemerge /mine:%NWN_HOME%\hak\%HAK_NAME%\2da\%2 /base:%NWN_HOME%\hak\%HAK_NAME%\%1\%2
copy %NWN_HOME%\hak\%HAK_NAME%\%2 %NWN_HOME%\hak\%HAK_NAME%\2da\%1.%2
goto mergeDone
:mergeMoveFile
echo %NWN_HOME%\hak\%HAK_NAME%\2da\%2 not found.
move %NWN_HOME%\hak\%HAK_NAME%\%1\%2 %NWN_HOME%\hak\%HAK_NAME%\.
goto mergeDone
:mergeDone
goto :EOF

:end
endlocal
start %NWN_HOME%\modules\Crewstopia.mod
