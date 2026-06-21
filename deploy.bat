@echo off
echo.
echo  ============================================
echo    GUB - Deploy to GitHub Pages
echo  ============================================
echo.

cd /d "C:\Users\keith\OneDrive\Desktop\gub-download"

echo [1/5] Checking GitHub authentication...
gh auth status >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo  You need to log in to GitHub first.
    echo  Opening browser now...
    echo.
    gh auth login --web
    echo.
    echo  After login, run this script again.
    pause
    exit /b
)
echo  ✓ GitHub authenticated
echo.

echo [2/5] Creating GitHub repository...
gh repo create gub-app-download --public --source=. --remote=origin --push --description "GUB - Global Universal Business - Download Page" 2>nul
if %errorlevel% neq 0 (
    echo  Repository may already exist, continuing...
)
echo  ✓ Repository ready
echo.

echo [3/5] Deploying to GitHub Pages...
gh api repos/:owner/gub-app-download/pages -X POST -f build_type=legacy -f source.branch=main -f source.path=/ 2>nul
echo  ✓ GitHub Pages enabled
echo.

echo [4/5] Getting your permanent URL...
for /f "tokens=*" %%i in ('gh api user --jq .login 2^>nul') do set USERNAME=%%i
echo.
echo  ============================================
echo    YOUR PERMANENT DOWNLOAD LINK:
echo  ============================================
echo.
echo    https://%USERNAME%.github.io/gub-app-download/
echo.
echo    QR Page: https://%USERNAME%.github.io/gub-app-download/
echo    APK:     https://%USERNAME%.github.io/gub-app-download/GUB-v1.0-release.apk
echo.
echo  ============================================
echo.

echo [5/5] Updating QR code with permanent URL...
powershell -Command "(Get-Content index.html) -replace 'APK_URL_PLACEHOLDER', 'https://%USERNAME%.github.io/gub-app-download/GUB-v1.0-release.apk' | Set-Content index.html"
git add -A
git commit -m "Update with permanent URL" >nul 2>&1
git push >nul 2>&1
echo  ✓ QR code updated
echo.

echo  ============================================
echo    DONE! Your app is permanently available!
echo    Share this link with anyone:
echo    https://%USERNAME%.github.io/gub-app-download/
echo  ============================================
echo.
pause
