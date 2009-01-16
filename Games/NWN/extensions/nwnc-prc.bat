@echo off
setlocal
set COMPILER=%NWN_HOME%\Utils\The_PRC1098057143201nwnnsscomp.exe
echo %COMPILER% -ego -i %NWN_HOME_PRC%\src\include -i . %*
%COMPILER% -ego -i %NWN_HOME_PRC%\src\include -i . %*
endlocal

