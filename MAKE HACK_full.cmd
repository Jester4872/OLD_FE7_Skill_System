cd %~dp0

copy FE7_clean.gba FE_Hack.gba

cd "%~dp0Tables"

echo: | (c2ea "%~dp0FE7_clean.gba")

cd "%~dp0Text"

echo: | (textprocess_v2 text_buildfile.txt)

cd "%~dp0Event Assembler"

Core A FE7 "-output:%~dp0FE_Hack.gba" "-input:%~dp0Buildfile.event"

pause
