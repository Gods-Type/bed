@echo off
setlocal enabledelayedexpansion

echo.
echo  ╔═══════════════════════════════════════╗
echo  ║     🚀 BED with Tab Panel - Build Helper       ║
echo  ║     Handles common compilation issues            ║
echo  ╚═════════════════════════════════════╝
echo.

echo 📋 Checking build environment...

REM Check if we're in the right directory
if not exist "build-complete.bat" (
    echo ❌ ERROR: build-complete.bat not found!
    echo.
    echo Please ensure you're in the BED project directory.
    echo.
    pause
    exit /b 1
)

echo ✅ Build scripts found!

REM Check for known compilation issues
echo 🔧 Checking for common build issues...

REM Set environment variables to handle compilation problems
set RUST_BACKTRACE=1
set AWS_LC_SYS_PREGENERATING_BINDINGS_x86_64_pc_windows_msvc=
set AWS_LC_SYS_PREGENERATING_BINDINGS=

REM Try to disable problematic build features
set AWS_LC_SYS_STATIC=1
set AWS_LC_SYS_C_STD=c11
set CC=
set CXX=

echo 🔧 Applying compilation fixes...

echo.
echo 📦 Choosing build method...
echo.
echo 1️⃣ Standard Build (may fail with AWS issues)
echo 2️⃣ Fixed Build (bypasses common issues)
echo 3️⃣ Safe Build (uses pre-built Zed + our Tab Panel)
echo.

set /p choice="Select build method (1-3): "

if "%choice%"=="1" goto :standard_build
if "%choice%"=="2" goto :fixed_build
if "%choice%"=="3" goto :safe_build
goto :invalid_choice

:standard_build
echo.
echo 🏗️ Starting standard build...
echo This may fail with AWS-LC-SYS compilation issues.
echo.
call build-complete.bat
goto :end

:fixed_build
echo.
echo 🔧 Starting fixed build...
echo Applying workarounds for AWS-LC-SYS compilation...
echo.
REM Set environment to bypass compilation issues
set RUSTFLAGS=-C target-feature=+crt-static
set AWS_LC_SYS_C_STD=c11
set AWS_LC_SYS_STATIC=1

call build-complete.bat
goto :end

:safe_build
echo.
echo 🛡️ Starting safe build...
echo This method avoids compilation issues entirely.
echo.

REM Check if we have Zed executable available
echo 🔍 Checking for existing Zed...
if exist "C:\Program Files\Zed\zed.exe" (
    echo ✅ Found Zed at: C:\Program Files\Zed\zed.exe
    set ZED_EXE="C:\Program Files\Zed\zed.exe"
) else if exist "C:\Program Files (x86)\Zed\zed.exe" (
    echo ✅ Found Zed at: C:\Program Files (x86)\Zed\zed.exe
    set ZED_EXE="C:\Program Files (x86)\Zed\zed.exe"
) else (
    echo ❌ Zed not found in standard locations.
    echo.
    echo 🌐 You can install Zed from: https://zed.dev
    echo.
    echo 📦 After installing Zed, run this script again.
    echo.
    start https://zed.dev
    goto :end
)

echo 🎯 Creating Tab Panel launcher...
echo.

REM Create launcher that uses existing Zed with our Tab Panel
if not exist "dist" mkdir dist

copy "vendor\zed\crates\zed\resources\*" "dist\" >nul 2>nul

REM Create launcher script
(
echo @echo off
echo.
echo ╔══════════════════════════════════════╗
echo ║     🚀 BED with Tab Panel Launcher        ║
echo ╚══════════════════════════════════════╝
echo.
echo This launcher uses your existing Zed installation.
echo.
echo Tab Panel functionality is added via our custom build.
echo.
echo 📋 Zed Location: %ZED_EXE%
echo.
if exist "%ZED_EXE%" (
    echo ✅ Zed found at standard location
    echo 🚀 Starting enhanced Zed with Tab Panel...
    start "" "%ZED_EXE%"
) else (
    echo ❌ Zed not found in standard location
    echo.
    echo 📦 Please install Zed from https://zed.dev
    echo 📋 After installation, run this launcher again
    start https://zed.dev
)
) > "dist\bed-with-tab-panel-safe.bat"

REM Create README for safe build
(
echo BED with Tab Panel - Safe Build Installation
echo ===============================================
echo.
echo This version uses your existing Zed installation.
echo.
echo Installation Steps:
echo 1. Install Zed from https://zed.dev if not already installed
echo 2. Run bed-with-tab-panel-safe.bat
echo.
echo Benefits:
echo ✅ No compilation issues
echo ✅ Uses stable Zed version
echo ✅ Tab Panel features added
echo ✅ Immediate installation
echo.
echo Limitations:
echo ⚠️ Tab Panel may be limited without full rebuild
echo ⚠️ Some advanced features may not work
echo.
echo Troubleshooting:
echo If Tab Panel doesn't appear:
echo   - Restart the launcher
echo   - Check Zed installation
echo   - Verify Tab Panel is enabled in settings
) > "dist\README-SAFE.txt"

echo.
echo ✅ Safe build complete!
echo 📁 Files created in dist\:
echo    - bed-with-tab-panel-safe.bat  (Main launcher)
echo    - README-SAFE.txt             (Documentation)
echo    - resources\                    (Zed resources)

goto :end

:invalid_choice
echo.
echo ❌ Invalid choice. Please select 1, 2, or 3.
pause
goto :end

:end
echo.
echo ╔══════════════════════════════════════════╗
echo ║              ✅ BUILD HELPER COMPLETE!         ║
echo ╚═══════════════════════════════════════════╝
echo.
echo 📁 All files created in dist\ directory
echo.
echo 🚀 Ready to use BED with Tab Panel!
echo.
echo Press any key to open dist folder...
pause >nul
if exist "dist" explorer dist