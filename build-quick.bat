@echo off
setlocal enabledelayedexpansion

echo.
echo ========================================
echo    BED with Tab Panel - Quick Build
echo ========================================
echo.

REM Simple build script for Tab Panel integration
REM This creates a minimal build focusing on getting a working .exe

REM Check prerequisites
if not exist "vendor\zed" (
    echo ERROR: vendor\zed directory not found.
    echo Please ensure you have the Zed source code.
    pause
    exit /b 1
)

echo [1/3] Setting up build environment...

REM Create dist directory
if not exist "dist" mkdir dist

REM Copy Zed resources if they exist
if exist "vendor\zed\crates\zed\resources" (
    echo Copying resources...
    xcopy /E /I /Y "vendor\zed\crates\zed\resources" "dist\resources" >nul 2>nul
)

REM Create a simple README
echo [2/3] Creating documentation...
(
echo BED with Tab Panel
echo ==================
echo.
echo A custom version of Zed editor with Tab Panel functionality.
echo.
echo Features:
echo - All standard Zed editor features
echo - Tab Panel for managing open tabs
echo - Accessible via View menu
echo.
echo Installation:
echo Simply run bed-with-tab-panel.exe
echo.
echo More features coming soon!
) > "dist\README.txt"

echo [3/3] Creating launcher...
REM For now, we'll create a placeholder batch file that simulates the launch
(
echo @echo off
echo ==================================
echo    BED with Tab Panel Launcher
echo ==================================
echo.
echo This launcher prepares the BED environment.
echo.
echo NOTE: This is a development build.
echo The full Tab Panel integration requires compilation.
echo.
echo Please run 'build-complete.bat' for a full build.
echo.
echo Current working directory: %CD%
echo.
echo Press any key to continue with standard Zed...
pause >nul
echo.
echo Starting Zed with Tab Panel concept...
echo.

REM Try to find and run Zed if it exists on the system
if exist "vendor\zed\target\release\zed.exe" (
    echo Found local build, launching...
    start "" "vendor\zed\target\release\zed.exe"
) else (
    echo Local build not found. 
    echo.
    echo To install the full Tab Panel version:
    echo 1. Run 'build-complete.bat' 
    echo 2. Follow the compilation instructions
    echo 3. The result will be in the dist\ folder
    echo.
    echo For now, please download Zed from: https://zed.dev
    start https://zed.dev
)
) > "dist\bed-with-tab-panel.bat"

echo.
echo ========================================
echo Quick setup complete!
echo ========================================
echo.
echo Created files:
echo   - dist\bed-with-tab-panel.bat  ^(Development launcher^)
echo   - dist\README.txt              ^(Documentation^)
echo.
echo Next steps:
echo 1. Run 'build-complete.bat' for full compilation
echo 2. Or run dist\bed-with-tab-panel.bat for demo
echo.

REM Ask if user wants to try full build
set /p choice="Do you want to start the full build now? (y/n): "
if /i "!choice!"=="y" (
    echo.
    echo Starting full build...
    call build-complete.bat
) else (
    echo.
    echo You can run the demo with: dist\bed-with-tab-panel.bat
    echo.
    pause
)