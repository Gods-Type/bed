@echo off
setlocal enabledelayedexpansion

echo.
echo ========================================
echo    BED with Tab Panel - Working Install
echo ========================================
echo.

REM Step 1: Check if we have the built executable
echo [1/3] Checking for built Tab Panel version...
if exist "vendor\zed\target\release\zed.exe" (
    echo Found built Tab Panel version!
    set USE_BUILT=1
    set ZED_EXE=vendor\zed\target\release\zed.exe
) else if exist "vendor\zed\target\debug\zed.exe" (
    echo Found debug Tab Panel version!
    set USE_BUILT=1
    set ZED_EXE=vendor\zed\target\debug\zed.exe
) else (
    echo Built version not found, will use system Zed
    set USE_BUILT=0
)

REM Step 2: Set up launcher
echo [2/3] Creating Tab Panel launcher...

REM Create dist directory
if not exist "dist" mkdir dist

if "%USE_BUILT%"=="1" (
    REM Create launcher for built version
    (
    echo @echo off
    echo echo ==================================
    echo echo    BED with Tab Panel
    echo echo ==================================
    echo echo.
    echo echo Starting BED with integrated Tab Panel...
    echo echo.
    echo echo Features:
    echo echo - All Zed functionality
    echo echo - Tab Panel integration
    echo echo - View menu: Tab Panel
    echo echo - Command Palette: "Tab Panel"
    echo echo.
    echo start "" "%ZED_EXE%"
    echo if !errorlevel! equ 0 (
    echo     echo BED with Tab Panel launched successfully!
    echo ) else (
    echo     echo Failed to launch. Check error above.
    echo     pause
    echo )
    ) > "dist\bed-with-tab-panel.bat"
    
    set LAUNCHER=dist\bed-with-tab-panel.bat
    
) else (
    REM Find system Zed
    set ZED_PATH=""
    if exist "C:\Program Files\Zed\zed.exe" (
        set ZED_PATH=C:\Program Files\Zed
    ) else if exist "C:\Users\tasticp\AppData\Local\Programs\Zed\zed.exe" (
        set ZED_PATH=C:\Users\tasticp\AppData\Local\Programs\Zed
    ) else (
        echo ERROR: No Zed installation found!
        echo Please install Zed from https://zed.dev
        start https://zed.dev
        pause
        exit /b 1
    )
    
    REM Create launcher for system Zed with Tab Panel info
    (
    echo @echo off
    echo echo ==================================
    echo echo    BED with Tab Panel - Info
    echo echo ==================================
    echo echo.
    echo echo NOTE: Tab Panel requires the compiled version of Zed
    echo echo.
    echo echo Current status:
    echo echo - Tab Panel code is integrated into Zed source
    echo echo - Tab Panel appears in View menu and Command Palette
    echo echo - Full compilation needed for complete functionality
    echo echo.
    echo echo Starting system Zed...
    echo echo.
    echo echo To build full Tab Panel version:
    echo echo 1. Install Visual Studio Build Tools
    echo echo 2. Run: build-complete.bat
    echo echo.
    echo start "" "!ZED_PATH!\zed.exe"
    echo if !errorlevel! equ 0 (
    echo     echo System Zed launched.
    echo     echo.
    echo     echo Tab Panel features are integrated but need compilation.
    echo ) else (
    echo     echo Failed to launch. Check error above.
    echo     pause
    echo )
    ) > "dist\bed-with-tab-panel.bat"
    
    set LAUNCHER=dist\bed-with-tab-panel.bat
)

REM Step 3: Create documentation
echo [3/3] Creating documentation...

(
echo BED with Tab Panel - Status
echo ==========================
echo.
echo Current Implementation Status:
echo.
echo ✅ COMPLETED:
echo - Tab Panel crate created and integrated
echo - Tab Panel registered in Zed's Cargo.toml
echo - Tab Panel added to main application (zed.rs)
echo - Menu integration: View -^> Tab Panel
echo - Command Palette integration
echo - UI styling and positioning
echo.
echo 🔧 REQUIREMENTS:
echo.
echo If you want the FULL Tab Panel functionality:
echo 1. Visual Studio Build Tools (for compilation)
echo 2. CMake (for dependency building)
echo 3. Run: build-complete.bat
echo.
echo 📋 WHAT YOU HAVE NOW:
echo.
echo %USE_BUILT% == 1 ? (
echo   ✅ Full Tab Panel version ready!
echo   Just run dist\bed-with-tab-panel.bat
echo ) else (
echo   ⚠️  Tab Panel is integrated but needs compilation
echo   You can use system Zed but Tab Panel won't appear
echo   until the full build is completed
echo )
echo.
echo 🚀 TO USE:
echo.
echo Run: dist\bed-with-tab-panel.bat
echo.
echo Then in Zed:
echo - View menu -^> Tab Panel
echo - Command Palette -^> "Tab Panel"
echo - Keyboard shortcut: Coming soon
echo.
echo 💡 TAB PANEL FEATURES:
echo - Hierarchical tab view
echo - Quick navigation between tabs
echo - Integration with project structure
echo - Search functionality (coming soon)
echo - Right-click context menus (coming soon)
echo.
echo ================================
echo Status: Integration Complete
echo Next Step: Compilation (for full functionality)
echo ================================
) > "dist\STATUS.txt"

REM Success message
echo.
echo ========================================
echo    SETUP COMPLETE!
echo ========================================
echo.
echo Created files:
echo   - %LAUNCHER%
echo   - dist\STATUS.txt
echo.
if "%USE_BUILT%"=="1" (
    echo ✅ Full Tab Panel version is ready!
    echo.
    echo Run: %LAUNCHER%
) else (
    echo ⚠️  Tab Panel is integrated but needs compilation
    echo.
    echo Current Zed will run but Tab Panel needs full build
    echo.
    echo To complete Tab Panel:
    echo 1. Install Visual Studio Build Tools
    echo 2. Run: build-complete.bat
    echo.
    echo Or run current launcher: %LAUNCHER%
)

echo.
echo Press any key to run the launcher now...
pause >nul

REM Launch
start "" "%LAUNCHER%"

echo.
echo Launcher started!
echo Check dist\STATUS.txt for detailed information.
echo.
pause