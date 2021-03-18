@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------    

::get vars from settings file
for /f "delims== tokens=1,2" %%G in (settings.txt) do set %%G=%%H

cls

::welcome message
echo Welcome to the Valheim Unified Tool Setup Wizard!
echo.
echo In a moment, you will be asked to create a GitHub repository to store your save files.
echo If you do not have a git account, please close this window, create a GitHub account and sign in,
echo then return here and try again.
echo ----------------------------

::open github and direct the user to create a repo
start "" https://github.com/new
echo You will need to create a new repository. Choose something meaningful for the Repository name and take note of it.
echo Make sure the repository is set to Public. You do not need to alter any other settings. When you are done, press Enter.
pause

::get the repo name
echo.
set /p githubname="Enter your GitHub name: "
set /p reponame="Enter the repository name: "
echo.
echo ----------------------------
echo You may now close your browser window.
echo.
echo ----------------------------

::create gitignore
cd /D C:\Users\%username%\AppData\LocalLow\IronGate\Valheim\worlds
echo steam_autocloud.vdf> ".gitignore"

::create local repo
echo "# Valheim Save Repository - Created using ValheimUnifiedTool">> README.md
git init
git add *
git commit -m "Repository created by script. Initial setup run successfully."
git branch -M main
git remote add origin git@github.com:%githubname%/%reponame%.git
git push -u origin main

