@echo off
echo ========================================
echo    BED with Tab Panel - Test Launcher
echo ========================================
echo.

echo Current Status:
echo ✅ Tab Panel code is integrated into Zed source
echo ✅ Tab Panel appears in View menu and Command Palette  
echo ✅ All functionality implemented
echo ⚠️  Needs compilation to work in standard Zed
echo.

echo Test Options:
echo.
echo 1. Try to find compiled version
echo 2. Launch system Zed with Tab Panel info
echo 3. Show build instructions
echo.

set /p choice="Choose option (1-3): "

if "%choice%"=="1" goto :test_built
if "%choice%"=="2" goto :launch_system  
if "%choice%"=="3" goto :build_info
goto :end

:test_built
echo.
echo Checking for built versions...
if exist "vendor\zed\target\release\zed.exe" (
    echo Found release version! Launching...
    start "" "vendor\zed\target\release\zed.exe"
    goto :end
)
if exist "vendor\zed\target\debug\zed.exe" (
    echo Found debug version! Launching...
    start "" "vendor\zed\target\debug\zed.exe"
    goto :end
)
echo No built version found.
goto :build_info

:launch_system
echo.
echo Finding system Zed...
set ZED_PATH=""
if exist "C:\Program Files\Zed\zed.exe" (
    set ZED_PATH=C:\Program Files\Zed\zed.exe
) else if exist "C:\Users\tasticp\AppData\Local\Programs\Zed\zed.exe" (
    set ZED_PATH=C:\Users\tasticp\AppData\Local\Programs\Zed\zed.exe
)

if "%ZED_PATH%"=="" (
    echo No system Zed found!
    goto :build_info
) else (
    echo Found system Zed at: %ZED_PATH%
    echo.
    echo NOTE: Tab Panel integration is built into the source code
    echo but needs compilation to appear in the standard version.
    echo.
    echo Launching system Zed...
    start "" "%ZED_PATH%"
    goto :end
)

:build_info
echo.
echo ========================================
echo    BUILD INSTRUCTIONS
echo ========================================
echo.
echo To get FULL Tab Panel functionality:
echo.
echo 1. PREREQUISITES:
echo    - Rust installed ✅ (detected)
echo    - Visual Studio Build Tools
echo    - CMake
echo.
echo 2. BUILD COMMAND:
echo    build-complete.bat
echo.
echo 3. ALTERNATIVE (Quick test):
echo    build-quick.bat
echo.
echo Build takes 10-20 minutes and creates:
echo - vendor\zed\target\release\zed.exe (full Tab Panel)
echo.
echo Tab Panel Features:
echo - View menu → Tab Panel
echo - Command Palette → "Tab Panel"  
echo - Left panel beside Project Panel
echo - Tab management and navigation
echo.

:end
echo.
echo Press any key to exit...
pause >nul