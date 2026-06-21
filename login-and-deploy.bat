@echo off
echo.
echo  ============================================
echo    GUB - GitHub Login & Deploy
echo  ============================================
echo.
echo  Step 1: Login to GitHub
echo  ========================
echo.
gh auth login -p https -h github.com -w
echo.
echo  ============================================
echo  Step 2: Deploy to GitHub Pages
echo  ============================================
echo.

cd /d "C:\Users\keith\OneDrive\Desktop\gub-download"

echo Creating repository...
gh repo create gub-app-download --public --source=. --remote=origin --push 2>nul
if %errorlevel% neq 0 (
    echo Repo may exist, pushing to it...
    git add -A
    git commit -m "Deploy GUB download page" 2>nul
    git push 2>nul
)

echo.
echo Enabling GitHub Pages...
gh api repos/:owner/gub-app-download/pages -X POST -f build_type=legacy -f source.branch=main -f source.path=/ 2>nul

echo.
echo Getting your URL...
for /f "tokens=*" %%i in ('gh api user --jq .login') do set USERNAME=%%i

echo.
echo  ============================================
echo    YOUR PERMANENT DOWNLOAD LINK:
echo  ============================================
echo.
echo    https://%USERNAME%.github.io/gub-app-download/
echo.
echo  ============================================
echo.

echo Updating QR code with your URL...
powershell -Command "$url = 'https://%USERNAME%.github.io/gub-app-download/GUB-v1.0-release.apk'; $html = Get-Content 'index.html' -Raw; $html = $html -replace 'APK_URL_PLACEHOLDER', $url; Set-Content 'index.html' $html -NoNewline"
git add -A
git commit -m "Update with permanent URL" 2>nul
git push 2>nul

echo.
echo  DONE! Your app is permanently available!
echo.
pause
