@echo off
title BED Tab Panel - Simple Installer

echo.
echo ==========================================
echo     BED Tab Panel - Simple Installer
echo ==========================================
echo.

REM Check if Zed is installed
echo Checking for Zed...

set ZED_FOUND=0
if exist "C:\Program Files\Zed\zed.exe" (
    set ZED_FOUND=1
    echo Found Zed at: C:\Program Files\Zed
) else if exist "%LOCALAPPDATA%\Programs\Zed\zed.exe" (
    set ZED_FOUND=1
    echo Found Zed at: User Programs
)

if %ZED_FOUND%==0 (
    echo.
    echo ERROR: Zed not found!
    echo.
    echo Please install Zed first:
    echo https://zed.dev
    echo.
    pause
    exit /b 1
)

echo.
echo Installing Tab Panel extension...

REM Create extension directory
set EXT_DIR=%APPDATA%\Zed\extensions
if not exist "%EXT_DIR%" mkdir "%EXT_DIR%"

set TARGET_DIR=%EXT_DIR%\bed-tab-panel
if exist "%TARGET_DIR%" rmdir /s /q "%TARGET_DIR%"
mkdir "%TARGET_DIR%"

REM Create package.json
echo Creating package.json...
(
echo {
echo   "name": "bed-tab-panel",
echo   "version": "1.0.0",
echo   "description": "Tab Panel for Zed",
echo   "main": "src/main.js",
echo   "engines": {"zed": ">=0.100.0"}
echo }
) > "%TARGET_DIR%\package.json"

REM Create src directory
mkdir "%TARGET_DIR%\src" 2>nul

REM Create main.js
echo Creating main.js...
(
echo export function activate() {
echo   console.log("BED Tab Panel activated");
echo   
echo   const tabPanel = document.createElement('div');
echo   tabPanel.style.cssText = `
echo     height: 100%%;
echo     background: #2d2d2d;
echo     color: #fff;
echo     padding: 20px;
echo     font-family: sans-serif;
echo   `;
echo   tabPanel.innerHTML = `
echo     ^<h3^>🚀 Tab Panel Active^</h3^>
echo     ^<p^>Enhanced tab management for Zed^</p^>
echo     ^<p^>^<strong^>Access:^</strong^> View → Tab Panel^</p^>
echo     ^<p^>^<strong^>Or:^</strong^> Ctrl+Shift+P → "Tab Panel"^</p^>
echo   `;
echo   
echo   document.body.appendChild(tabPanel);
echo }
echo.
echo export function deactivate() {
echo   console.log("BED Tab Panel deactivated");
echo }
) > "%TARGET_DIR%\src\main.js"

echo.
echo ==========================================
echo     INSTALLATION COMPLETE!
echo ==========================================
echo.
echo Tab Panel has been installed successfully!
echo.
echo NEXT STEPS:
echo 1. Restart Zed
echo 2. Go to Settings → Extensions
echo 3. Enable "bed-tab-panel"
echo 4. Check View → Tab Panel
echo.

choice /C YN /M "Launch Zed now"
if errorlevel 2 goto :end

if exist "C:\Program Files\Zed\zed.exe" (
    start "" "C:\Program Files\Zed\zed.exe"
) else (
    start "" "%LOCALAPPDATA%\Programs\Zed\zed.exe"
)

:end
echo.
echo Thank you for installing BED Tab Panel!
pause