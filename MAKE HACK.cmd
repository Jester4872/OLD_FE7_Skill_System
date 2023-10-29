cd %~dp0
copy "FE7_clean.gba" "FE_Hack.gba"
cd "%~dp0Event_Assembler"
Core A FE7 "-output:%~dp0FE_Hack.gba" "-input:%~dp0Buildfile.event"
pause