@echo off
setlocal
set COMPILER=%NWN_HOME%\Utils\The_PRC1098057143201nwnnsscomp.exe
echo %COMPILER% -ego -i %NWN_HOME%\extensions\Custom -i %NWN_HOME_CEP%\src\include -i %NWN_HOME_CEP%\src\scripts -i %NWN_HOME_PRC%\src\include -i %NWN_HOME%\extensions\Custom\Override\include -i . %*
%COMPILER% -ego -i %NWN_HOME%\extensions\Custom -i %NWN_HOME_CEP%\src\include -i %NWN_HOME_CEP%\src\scripts -i %NWN_HOME_PRC%\src\include -i %NWN_HOME%\extensions\Custom\Override\include -i . %*
endlocal

