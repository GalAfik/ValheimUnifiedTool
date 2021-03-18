@echo off
for /f "delims== tokens=1,2" %%G in (settings.txt) do set %%G=%%H

cd /D C:\Users\%username%\AppData\LocalLow\IronGate\Valheim\worlds
git pull origin main
%steamlocation%\Steam\steamapps\common\Valheim\valheim.exe