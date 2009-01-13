@echo off
setlocal
REM set NWN_HOME_PRC=F:\Games\NWN\extensions\PrC2.3a9
set COMPILER=F:\Games\NWN\Utils\The_PRC1098057143201nwnnsscomp.exe
echo %COMPILER% -ego -i %NWN_HOME%\extensions\Custom -i %NWN_HOME_CEP%\src\include -i %NWN_HOME_CEP%\src\scripts -i . %*
%COMPILER% -ego -i %NWN_HOME%\extensions\Custom -i %NWN_HOME_CEP%\src\include -i %NWN_HOME_CEP%\src\scripts -i . %*
endlocal

