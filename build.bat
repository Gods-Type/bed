@echo off
setlocal enabledelayedexpansion

echo.
echo ========================================
echo    Building BED with Tab Panel
    (Simplified Build Script)
echo ========================================
echo.

REM Check if vendor/zed exists
if not exist "vendor\zed" (
    echo ERROR: vendor\zed directory not found.
    echo Please run this script from the bed project root.
    pause
    exit /b 1
)

REM Check if Rust is installed
where cargo >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Rust/Cargo not found.
    echo Please install Rust from https://rustup.rs/
    pause
    exit /b 1
)

echo [1/3] Checking environment... OK
echo.

REM Try to build with AWS-LC-SYS fixes
echo [2/3] Building Zed with Tab Panel...
echo Applying AWS-LC-SYS compilation fixes...

set AWS_LC_SYS_STATIC=1
set AWS_LC_SYS_C_STD=c11
set RUSTFLAGS=-C target-feature=+crt-static

cd vendor\zed
cargo build --release --bin zed
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Build failed with AWS-LC-SYS issues!
    echo.
    echo Trying alternative approach...
    echo.

    REM Try without the problematic features
    echo [2/3] Attempting build without problematic features...
    cargo build --release --bin zed --no-default-features
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Alternative build also failed!
        echo.
        echo Please try the safe build method:
        echo 1. Install Zed from https://zed.dev
        echo 2. Use build-helper.bat for safe installation
        cd ..\..
        pause
        exit /b 1
    )
)
cd ..\..

echo [2/3] Build completed successfully!
echo.

REM Create distributable package
echo [3/3] Creating distributable package...
if not exist "dist" mkdir dist

REM Copy executable
copy "vendor\zed\target\release\zed.exe" "dist\bed-with-tab-panel.exe" >nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to copy executable!
    pause
    exit /b 1
)

REM Copy resources if they exist
if exist "vendor\zed\crates\zed\resources" (
    xcopy /E /I /Y "vendor\zed\crates\zed\resources" "dist\resources" >nul
)

REM Create README
(
echo BED with Tab Panel
echo ==================
echo.
echo This is a custom build of Zed editor with the Tab Panel feature added.
echo.
echo Features:
echo - All standard Zed features
echo - New Tab Panel for managing tabs in a hierarchical view
echo - Toggle Tab Panel via View menu or action palette
echo - Tab Panel appears beside Project Panel
echo.
echo Installation:
echo 1. Run bed-with-tab-panel.exe
echo 2. The editor will start with Tab Panel enabled
echo.
echo To toggle Tab Panel:
echo - Go to View -> Tab Panel
echo - Or use the action palette and search for "Tab Panel"
echo.
echo This is an experimental build. Please report any issues.
) > "dist\README.txt"

echo.
echo ========================================
echo Build completed successfully!
echo ========================================
echo.
echo Output files created in dist\:
echo   - bed-with-tab-panel.exe  (Main executable)
echo   - README.txt              (Documentation)
echo.
echo To run:
echo   dist\bed-with-tab-panel.exe
echo.
echo Press any key to open the dist folder...
pause >nul
explorer dist
