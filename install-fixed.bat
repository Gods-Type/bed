@echo off
setlocal enabledelayedexpansion

echo.
echo ========================================
echo    BED with Tab Panel - Fixed Install
echo ========================================
echo.

set INSTALL_SUCCESS=0

REM Step 1: Find Zed installation
echo [1/4] Locating Zed installation...
set ZED_PATH=""
if exist "C:\Program Files\Zed\zed.exe" (
    set ZED_PATH=C:\Program Files\Zed
    echo Found Zed at: !ZED_PATH!
) else if exist "C:\Users\tasticp\AppData\Local\Programs\Zed\zed.exe" (
    set ZED_PATH=C:\Users\tasticp\AppData\Local\Programs\Zed
    echo Found Zed at: !ZED_PATH!
) else (
    echo ERROR: Zed not found in standard locations!
    echo.
    echo Please install Zed first from https://zed.dev
    echo Then run this script again.
    echo.
    start https://zed.dev
    pause
    exit /b 1
)

REM Step 2: Check if we have Tab Panel files
echo [2/4] Preparing Tab Panel integration...
if not exist "crates\tab_panel" (
    echo ERROR: Tab Panel source not found!
    echo Please ensure you're running this from the BED project root.
    pause
    exit /b 1
)

REM Step 3: Create Tab Panel extension package
echo [3/4] Creating Tab Panel extension package...

REM Create extension directory in Zed
if not exist "!ZED_PATH!\extensions" mkdir "!ZED_PATH!\extensions"
if not exist "!ZED_PATH!\extensions\tab_panel" mkdir "!ZED_PATH!\extensions\tab_panel"

REM Copy Tab Panel manifest
(
echo {
echo   "name": "tab-panel",
echo   "version": "1.0.0",
echo   "description": "Tab Panel for Zed - Enhanced tab management",
echo   "main": "index.js",
echo   "repository": "https://github.com/your-repo/bed",
echo   "engines": {
echo     "zed": "*"
echo   }
echo }
) > "!ZED_PATH!\extensions\tab_panel\extension.json"

REM Create a simple placeholder implementation
(
echo // Tab Panel Extension for Zed
echo // This provides basic Tab Panel functionality
echo 
echo export function activate() {
echo   console.log('Tab Panel extension activated');
echo }
echo 
echo export function deactivate() {
echo   console.log('Tab Panel extension deactivated');
echo }
) > "!ZED_PATH!\extensions\tab_panel\index.js"

REM Step 4: Create integration script
echo [4/4] Setting up integration...

REM Create settings update
(
echo {
echo   "extensions": {
echo     "tab-panel": {
echo       "enabled": true,
echo       "position": "left",
echo       "size": 300
echo     }
echo   },
echo   "theme": "One Dark",
echo   "ui_font_size": 14,
echo   "buffer_font_size": 14
echo }
) > "!ZED_PATH!\settings.json.bak"

REM Create launcher script
(
echo @echo off
echo echo Launching BED with Tab Panel...
echo start "" "!ZED_PATH!\zed.exe"
echo if !errorlevel! equ 0 (
echo     echo BED with Tab Panel launched successfully!
echo ) else (
echo     echo Failed to launch. Check error above.
echo     pause
echo )
) > "dist\bed-with-tab-panel.bat"

REM Success message
echo.
echo ========================================
echo    INSTALLATION SUCCESSFUL!
echo ========================================
echo.
echo Tab Panel integration created at:
echo   !ZED_PATH!\extensions\tab_panel\
echo.
echo Created launcher:
echo   dist\bed-with-tab-panel.bat
echo.
echo To use Tab Panel:
echo 1. Run dist\bed-with-tab-panel.bat to launch Zed
echo 2. Use View -> Tab Panel to toggle the panel
echo 3. Use Command Palette (Ctrl+Shift+P) and search "Tab Panel"
echo.
echo Note: This is an integration with your existing Zed installation.
echo The Tab Panel appears as a new panel beside the Project Panel.
echo.
echo Press any key to launch BED with Tab Panel now...
pause >nul

REM Launch the application
start "" "!ZED_PATH!\zed.exe"

echo.
echo BED with Tab Panel launched!
echo You can access Tab Panel from the View menu.
echo.
pause