@echo off
for /f "delims== tokens=1,2" %%G in (settings.txt) do set %%G=%%H

cd /D C:\Users\%username%\AppData\LocalLow\IronGate\Valheim\worlds
git add *
set /p usercomment="What did you do this session? Enter your comments: "
git commit -m "%usercomment%"
git push origin main
