@echo off
title GUB GitHub Setup
color 0B
echo.
echo  ================================================
echo    GUB - GitHub Login (stays open until done)
echo  ================================================
echo.
echo  1. Open your browser and go to:
echo.
echo     https://github.com/login/device
echo.
echo  2. When prompted, enter the code shown below:
echo.
echo  ================================================
echo.

gh auth login -p https -h github.com -w

echo.
echo  ================================================
echo  Login complete! Now deploying...
echo  ================================================
echo.

cd /d "C:\Users\keith\OneDrive\Desktop\gub-download"

echo [1/3] Creating repo and pushing...
git init
git remote remove origin 2>nul
gh repo create gub-app-download --public --source=. --remote=origin --push 2>nul
if %errorlevel% neq 0 (
    git add -A
    git commit -m "Deploy GUB download page" 2>nul
    git push -u origin main 2>nul
)

echo [2/3] Enabling GitHub Pages...
gh api repos/:owner/gub-app-download/pages -X POST -f build_type=legacy -f source.branch=main -f source.path=/ 2>nul

echo [3/3] Getting your permanent URL...
for /f "tokens=*" %%i in ('gh api user --jq .login') do set GHUSER=%%i

echo.
echo  ================================================
echo    YOUR PERMANENT LINK IS READY:
echo  ================================================
echo.
echo    https://%GHUSER%.github.io/gub-app-download/
echo.
echo    Share this QR code with anyone to install GUB!
echo  ================================================
echo.
pause
