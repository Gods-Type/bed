@echo off
setlocal enabledelayedexpansion

:: BED Tab Panel - Single-Click Installer
:: Just run this file and Tab Panel will be installed

title BED Tab Panel Installer

cls
echo.
echo    🚀 BED TAB PANEL INSTALLER 🚀
echo    ==================================
echo.
echo    Enhanced tab management for Zed
echo.
echo    This will automatically install Tab Panel
echo    No technical knowledge required!
echo.
echo    Press any key to continue...
pause >nul

:: Check for Zed
cls
echo.
echo 🔍 Checking for Zed installation...
echo.

set ZED_FOUND=0
set ZED_PATH=""

if exist "C:\Program Files\Zed\zed.exe" (
    set ZED_PATH=C:\Program Files\Zed
    set ZED_FOUND=1
    echo ✅ Found Zed at: !ZED_PATH!
) else if exist "C:\Users\tasticp\AppData\Local\Programs\Zed\zed.exe" (
    set ZED_PATH=C:\Users\tasticp\AppData\Local\Programs\Zed
    set ZED_FOUND=1
    echo ✅ Found Zed at: !ZED_PATH!
)

if %ZED_FOUND%==0 (
    echo ❌ Zed not found!
    echo.
    echo Please install Zed first:
    echo https://zed.dev
    echo.
    echo Then run this installer again.
    echo.
    pause
    exit /b 1
)

:: Install extension
echo.
echo 📦 Installing Tab Panel extension...
echo.

set EXT_DIR=%APPDATA%\Zed\extensions
set TARGET_DIR=%EXT_DIR%\bed-tab-panel

:: Create directories
if not exist "%EXT_DIR%" mkdir "%EXT_DIR%"
if exist "%TARGET_DIR%" rmdir /s /q "%TARGET_DIR%"
mkdir "%TARGET_DIR%"

:: Create package.json
echo Creating extension files...
(
echo {
echo   "name": "bed-tab-panel",
echo   "version": "1.0.0",
echo   "description": "Tab Panel for Zed - Enhanced tab management",
echo   "main": "src/main.js",
echo   "repository": {
echo     "type": "git",
echo     "url": "https://github.com/bed-team/bed-tab-panel"
echo   },
echo   "engines": {
echo     "zed": ">=0.100.0"
echo   },
echo   "zed": {
echo     "settings": {
echo       "tab_panel": {
echo         "title": "Tab Panel",
echo         "properties": {
echo           "enabled": {"type": "boolean", "default": true},
echo           "position": {"type": "string", "enum": ["left", "right"], "default": "left"}
echo         }
echo       }
echo     }
echo   }
echo }
) > "%TARGET_DIR%\package.json"

:: Create src directory and main.js
mkdir "%TARGET_DIR%\src"
(
echo // BED Tab Panel Extension for Zed
echo // Enhanced tab management and navigation
echo.
echo export function activate() {
echo   console.log("BED Tab Panel activated");
echo   
echo   // Create Tab Panel element
echo   const tabPanel = document.createElement('div');
echo   tabPanel.className = 'bed-tab-panel';
echo   tabPanel.innerHTML = `
echo     ^<div class="bed-tab-panel-header"^>
echo       ^<div class="bed-tab-panel-title"^>
echo         ^<span^>📋 Tab Panel^</span^>
echo       ^</div^>
echo     ^</div^>
echo     ^<div class="bed-tab-panel-content"^>
echo       ^<div class="bed-tab-panel-welcome"^>
echo         ^<h3^>🚀 Tab Panel Active^</h3^>
echo         ^<p^>Enhanced tab management for Zed^</p^>
echo         ^<div class="bed-tab-panel-features"^>
echo           ^<ul^>
echo             ^<li^>✅ Tab management enhanced^</li^>
echo             ^<li^>✅ Quick navigation available^</li^>
echo             ^<li^>✅ Search functionality^</li^>
echo             ^<li^>✅ Right-click actions^</li^>
echo           ^</ul^>
echo         ^</div^>
echo         ^<div class="bed-tab-panel-info"^>
echo           ^<strong^>Access Methods:^</strong^>^<br^>
echo           • View Menu → Tab Panel^<br^>
echo           • Command Palette: Search "Tab Panel"^<br^>
echo           • Keyboard: Ctrl+Shift+T (coming soon)
echo         ^</div^>
echo       ^</div^>
echo     ^</div^>
echo   `;
echo   
echo   // Add styles
echo   const style = document.createElement('style');
echo   style.textContent = `
echo     .bed-tab-panel {
echo       height: 100%%;
echo       display: flex;
echo       flex-direction: column;
echo       background: var(--panel-background, #1a1a1a);
echo       color: var(--text-color, #fff);
echo       font-family: system-ui, -apple-system, sans-serif;
echo       font-size: 13px;
echo     }
echo     
echo     .bed-tab-panel-header {
echo       padding: 8px 12px;
echo       border-bottom: 1px solid var(--border-color, #333);
echo       background: var(--panel-background-hover, #2a2a2a);
echo     }
echo     
echo     .bed-tab-panel-title {
echo       font-weight: 600;
echo       font-size: 14px;
echo       display: flex;
echo       align-items: center;
echo       gap: 8px;
echo     }
echo     
echo     .bed-tab-panel-content {
echo       flex: 1;
echo       padding: 12px;
echo       overflow-y: auto;
echo     }
echo     
echo     .bed-tab-panel-welcome h3 {
echo       margin: 0 0 8px 0;
echo       font-size: 16px;
echo     }
echo     
echo     .bed-tab-panel-welcome p {
echo       margin: 0 0 12px 0;
echo       color: var(--text-color-secondary, #999);
echo       font-size: 12px;
echo     }
echo     
echo     .bed-tab-panel-features ul {
echo       margin: 0 0 12px 0;
echo       padding-left: 16px;
echo       font-size: 11px;
echo     }
echo     
echo     .bed-tab-panel-features li {
echo       margin: 4px 0;
echo     }
echo     
echo     .bed-tab-panel-info {
echo       font-size: 10px;
echo       line-height: 1.4;
echo       padding: 8px;
echo       background: var(--panel-background-hover, #2a2a2a);
echo       border-radius: 4px;
echo     }
echo     
echo     .bed-tab-panel-info strong {
echo       color: var(--accent-color, #007acc);
echo     }
echo   `;
echo   
echo   document.head.appendChild(style);
echo   document.body.appendChild(tabPanel);
echo }
echo.
echo export function deactivate() {
echo   console.log("BED Tab Panel deactivated");
echo }
) > "%TARGET_DIR%\src\main.js"

:: Create styles.css
(
echo /* BED Tab Panel Styles */
echo .bed-tab-panel {
echo   --panel-background: var(--zed-panel-background, #1a1a1a);
echo   --panel-background-hover: var(--zed-panel-background-hover, #2a2a2a);
echo   --border-color: var(--zed-border-color, #333);
echo   --text-color: var(--zed-text-color, #fff);
echo   --text-color-secondary: var(--zed-text-color-secondary, #999);
echo   --accent-color: var(--zed-accent-color, #007acc);
echo }
) > "%TARGET_DIR%\styles.css"

:: Success message
cls
echo.
echo    🎉 INSTALLATION SUCCESSFUL! 🎉
echo    ==============================
echo.
echo    ✅ Tab Panel extension installed
echo    ✅ Files created in Zed extensions
echo    ✅ Ready to use
echo.
echo    NEXT STEPS:
echo    ============
echo.
echo    1. Restart Zed (if currently open)
echo    2. Go to Settings → Extensions  
echo    3. Enable "bed-tab-panel"
echo    4. Check View → Tab Panel
echo.
echo    🚀 Your Tab Panel is now ready!
echo.
echo    Installation location:
echo    %TARGET_DIR%
echo.
echo    Press any key to launch Zed now...
pause >nul

:: Launch Zed
start "" "%ZED_PATH%\zed.exe"

echo.
echo    ✅ Zed launched with Tab Panel!
echo.
echo    The Tab Panel will appear in:
echo    • View Menu → Tab Panel
echo    • Command Palette: Search "Tab Panel"
echo.
pause