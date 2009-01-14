@echo off
set NWN_HOME_PRC_SERVER=%CD%
cd %NWN_HOME_PRC_SERVER%
if not exist %NWN_HOME_PRC_SERVER%\temp\. mkdir %NWN_HOME_PRC_SERVER%\temp
del /q %NWN_HOME_PRC_SERVER%\temp\*.*
cd %NWN_HOME_PRC_SERVER%\temp
echo Unpacking files...
call erf.bat -x %NWN_HOME%\hak\prc_2das.hak *.2da
call erf.bat -x %NWN_HOME%\hak\prc_race.hak *.2da
call erf.bat -x %NWN_HOME%\hak\prc_craft2das.hak *.2da
call erf.bat -x %NWN_HOME%\hak\dac_palette.hak *.2da
call erf.bat -x %NWN_HOME%\hak\dac_override.hak *.2da
echo Moving files...
if not exist %NWN_HOME_PRC_SERVER%\precacher2das\. mkdir %NWN_HOME_PRC_SERVER%\precacher2das
move *.2da %NWN_HOME_PRC_SERVER%\precacher2das\.
cd %NWN_HOME_PRC_SERVER%
del /s /q temp
echo Generating SQL...
cd %NWN_HOME_PRC_SERVER%
java -Xmx200m -jar prc.jar 2datosql precacher2das MySQL
del precache.mysql.old
rename precache.mysql precache.mysql.old
rename out.sql precache.mysql
echo Executing SQL...
call mysql-crewstopia.bat precache.mysql
echo done.