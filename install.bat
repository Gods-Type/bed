@echo off
setlocal enabledelayedexpansion

echo.
echo  ╔══════════════════════════════════════════╗
echo  ║     🚀 BED with Tab Panel Installer        ║
echo  ║                                            ║
echo  ║  Enhanced Zed Editor with Tab Management     ║
echo  ║                                            ║
echo  ╚══════════════════════════════════════════╝
echo.

REM Check if we're in the right directory
if not exist "build-quick.bat" (
    echo ❌ ERROR: build scripts not found!
    echo.
    echo Please ensure you're in the BED project directory.
    echo The directory should contain:
    echo   - build-quick.bat
    echo   - build-complete.bat  
    echo   - README.md
    echo.
    pause
    exit /b 1
)

echo 🔍 Checking build options...
echo.
echo 1️⃣  Quick Demo     - 2 minutes, shows concept
echo 2️⃣  Full Build     - 15 minutes, complete Tab Panel
echo 3️⃣  Exit
echo.

set /p choice="Select option (1-3): "

if "%choice%"=="1" goto :quick_build
if "%choice%"=="2" goto :full_build  
if "%choice%"=="3" goto :exit
goto :invalid_choice

:quick_build
echo.
echo 🏃‍♂️ Starting Quick Demo Build...
echo.
call build-quick.bat
goto :show_results

:full_build
echo.
echo 🏗️ Starting Full Build (this will take 15-20 minutes)...
echo ⏳ Please be patient, this is a one-time process...
echo.
call build-complete.bat
goto :show_results

:show_results
echo.
echo ╔══════════════════════════════════════════╗
echo  ║              ✅ BUILD COMPLETE!               ║
echo  ╚══════════════════════════════════════════╝
echo.
if exist "dist\bed-with-tab-panel.exe" (
    echo 🎯 SUCCESS: Full executable created!
    echo    Location: dist\bed-with-tab-panel.exe
    echo.
    echo 📦 Installation Options:
    echo    1. Run dist\install.bat for automatic setup
    echo    2. Run dist\bed-with-tab-panel.exe directly
    echo    3. Use dist\portable\ for portable version
) else (
    echo 📦 Demo files created!
    echo    Location: dist\bed-with-tab-panel.bat
    echo.
    echo 📖 Next Steps:
    echo    1. Run build-complete.bat for full version
    echo    2. Or use the demo launcher
)

echo.
echo 📁 All files are in the dist\ folder:
echo.
dir /b dist\
echo.
echo 🚀 Ready to use BED with Tab Panel!
goto :exit

:invalid_choice
echo.
echo ❌ Invalid choice. Please select 1, 2, or 3.
goto :exit

:exit
echo.
echo Press any key to open the dist folder...
pause >nul
if exist "dist" explorer dist
pause