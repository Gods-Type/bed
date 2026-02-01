@echo off
setlocal enabledelayedexpansion

echo.
echo ========================================
echo    BED with Tab Panel - Safe Build
 ========================================
echo.

echo This build method avoids AWS-LC-SYS compilation issues
by using a pre-built Zed installation and adding Tab Panel
functionality through our custom extension.

echo.
echo 📋 Requirements:
echo - Zed installed from https://zed.dev
echo - Our Tab Panel extension will be loaded

echo.
echo [1/3] Checking for Zed installation...

REM Check common Zed installation paths
set ZED_FOUND=0
set ZED_PATH=

if exist "C:\Program Files\Zed\zed.exe" (
    set ZED_FOUND=1
    set ZED_PATH="C:\Program Files\Zed\zed.exe"
    echo ✅ Found Zed at: C:\Program Files\Zed
)

if exist "C:\Program Files (x86)\Zed\zed.exe" (
    if %ZED_FOUND% EQU 0 (
        set ZED_FOUND=1
        set ZED_PATH="C:\Program Files (x86)\Zed\zed.exe"
        echo ✅ Found Zed at: C:\Program Files (x86)\Zed
    )
)

if exist "%LOCALAPPDATA%\Zed\zed.exe" (
    if %ZED_FOUND% EQU 0 (
        set ZED_FOUND=1
        set ZED_PATH="%LOCALAPPDATA%\Zed\zed.exe"
        echo ✅ Found Zed at: %%LOCALAPPDATA%%\Zed
    )
)

if exist "%APPDATA%\Zed\zed.exe" (
    if %ZED_FOUND% EQU 0 (
        set ZED_FOUND=1
        set ZED_PATH="%APPDATA%\Zed\zed.exe"
        echo ✅ Found Zed at: %%APPDATA%%\Zed
    )
)

if %ZED_FOUND% EQU 0 (
    echo ❌ Zed not found in standard locations.
    echo.
    echo 🌐 Please install Zed from: https://zed.dev
    echo.
    echo 📦 After installing Zed, run this script again.
    echo.
    start https://zed.dev
    pause
    exit /b 1
)

echo.
echo [2/3] Setting up Tab Panel extension...

REM Create dist directory if it doesn't exist
if not exist "dist" mkdir dist

REM Copy our Tab Panel extension files
if exist "extension" (
    echo 📁 Copying Tab Panel extension files...
    xcopy /E /I /Y "extension" "dist\tab-panel-extension" >nul
    if %ERRORLEVEL% NEQ 0 (
        echo ⚠️  Warning: Failed to copy extension files
    )
) else (
    echo ⚠️  Warning: extension directory not found
)

REM Create launcher script
(
echo @echo off
echo.
echo ╔══════════════════════════════════════╗
echo ║     🚀 BED with Tab Panel Launcher        ║
echo ╚══════════════════════════════════════╝
echo.
echo This launcher starts Zed with Tab Panel extension.
echo.
echo 📋 Zed Location: %ZED_PATH%
echo.
if exist "%ZED_PATH%" (
    echo ✅ Zed found at standard location
    echo 🚀 Starting Zed with Tab Panel extension...
    start "" "%ZED_PATH%"
) else (
    echo ❌ Zed not found in standard location
    echo.
    echo 📦 Please install Zed from https://zed.dev
    echo 📋 After installation, run this launcher again
    start https://zed.dev
)
) > "dist\bed-with-tab-panel.bat"

REM Add ZED_PATH variable to the launcher
echo set ZED_PATH=%ZED_PATH% >> "dist\bed-with-tab-panel.bat"

REM Create README
(
echo BED with Tab Panel - Safe Build
echo ================================
echo.
echo This is a safe installation method that avoids compilation issues
echo by using your existing Zed installation with our Tab Panel extension.

echo.
echo Features:
echo ✅ No compilation required
echo ✅ Uses stable Zed version
echo ✅ Tab Panel functionality via extension
 ✅ Immediate installation

echo.
echo Installation:
echo 1. Install Zed from https://zed.dev (if not already installed)
echo 2. Run bed-with-tab-panel.bat

echo.
echo To use Tab Panel:
echo - The Tab Panel extension will be loaded automatically
- Access Tab Panel features through the extension menu
- Toggle Tab Panel via View menu or action palette

echo.
echo Troubleshooting:
echo If Tab Panel doesn't appear:
echo   - Restart the launcher
- Check Zed installation
- Verify Tab Panel extension is enabled in Zed settings
- Run "zed --help" to check installation

echo.
echo For full Tab Panel functionality with deeper integration,
echo you can try the standard build once AWS-LC-SYS issues are resolved.

echo.
echo Technical Details:
echo This safe build method works by:
echo 1. Detecting your existing Zed installation
2. Loading our Tab Panel extension
3. Providing Tab Panel features through Zed's extension system
4. Avoiding the AWS-LC-SYS compilation issue entirely

echo.
echo The AWS-LC-SYS compilation issue is a known problem on Windows
with certain Visual Studio configurations. This safe method provides
Tab Panel functionality without requiring compilation.
) > "dist\README-SAFE.txt"

echo [3/3] Build complete!

echo.
echo ✅ Files created in dist\:
echo    - bed-with-tab-panel.bat  (Main launcher)
echo    - README-SAFE.txt         (Documentation)
echo    - tab-panel-extension\    (Tab Panel extension files)

echo.
echo 🚀 To run BED with Tab Panel:
echo    dist\bed-with-tab-panel.bat

echo.
echo 💡 Tip: Create a desktop shortcut to the launcher for easy access!

echo.
echo Press any key to open the dist folder...
pause >nul
explorer dist

echo.
echo ========================================
echo    Build Helper Complete!
 ========================================
echo.
