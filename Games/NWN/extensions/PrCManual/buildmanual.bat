@echo off
if exist buildmanual.log del buildmanual.log
if exist manual\. del /s /q manual
xcopy /iey manual_template manual || goto end
javac prc\*.java
xcopy /iey %NWN_HOME_PRC%\src\2da\*.2da 2da\.
xcopy /iey %NWN_HOME_PRC%\src\craft_2das\*.2da 2da\.
xcopy /iey %NWN_HOME_PRC%\src\race\*.2da 2da\.
xcopy /iey %NWN_HOME%\extensions\Custom\Palette\2da\*.2da 2da\.
xcopy /iey %NWN_HOME%\extensions\Custom\Override\2da\*.2da 2da\.
xcopy /iey %NWN_HOME%\extensions\Custom\Override\2HandWield\*.2da 2da\.
xcopy /iey %NWN_HOME%\extensions\Custom\Override\EpicSpells\*.2da 2da\.
xcopy /iey %NWN_HOME%\extensions\Custom\Override\FightOrFlight\*.2da 2da\.
xcopy /iey %NWN_HOME%\extensions\Custom\Override\PnPShifter\*.2da 2da\.
xcopy /iey %NWN_HOME%\extensions\Custom\Override\Psionics\*.2da 2da\.
xcopy /iey %NWN_HOME%\extensions\Custom\Override\Race\*.2da 2da\.
xcopy /iey %NWN_HOME%\extensions\Custom\Override\Soulknife\*.2da 2da\.
xcopy /iey %NWN_HOME%\extensions\Custom\Override\Spells\*.2da 2da\.
REM make
java -Xmx300m -Xms300m prc/autodoc/Main 2>buildmanual.log || goto end
REM make run_icons
java -Xmx300m -Xms300m prc/autodoc/Main -i 2>>buildmanual.log || goto end
start manual\index.html
:end
