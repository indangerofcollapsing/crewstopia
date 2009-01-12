@echo off
setlocal
set currdir=%CD%
cd src
echo Compiling...
javac CharacterCreator\*.java || goto end
echo Updating jar...
jar -uf ..\CharacterCreator.jar CharacterCreator\*.java CharacterCreator\*.class || goto end
echo Success.

:end
cd %currdir%
endlocal