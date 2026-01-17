@echo off
REM Build script for Zed with Tab Panel on Windows
setlocal enabledelayedexpansion

echo.
echo ========================================
echo    Building BED with Tab Panel
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

echo [1/4] Checking environment... OK
echo.

REM Clean previous builds
if exist "vendor\zed\target\release" (
    echo [2/4] Cleaning previous builds...
    rmdir /s /q "vendor\zed\target\release" >nul 2>nul
)
echo [2/4] Previous builds cleaned...
echo.

REM Build Zed
echo [3/4] Building Zed with Tab Panel...
cd vendor\zed
cargo build --release --bin zed
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)
cd ..\..
echo [3/4] Build completed successfully!
echo.

REM Create distributable package
echo [4/4] Creating distributable package...
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
echo Creating README...
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
echo - Go to View -^> Tab Panel
echo - Or use the action palette and search for "Tab Panel"
echo.
echo This is an experimental build. Please report any issues.
) > "dist\README.txt"

REM Create installer
echo Creating installer...
(
echo @echo off
echo Installing BED with Tab Panel...
echo.
echo REM Create installation directory
echo if not exist "%%APPDATA%%\BED" mkdir "%%APPDATA%%\BED"
echo.
echo REM Copy files
echo copy "bed-with-tab-panel.exe" "%%APPDATA%%\BED\"
echo if exist "resources" xcopy /E /I /Y "resources" "%%APPDATA%%\BED\resources\"
echo.
echo REM Create desktop shortcut
echo powershell -Command "%%WshShell = New-Object -comObject WScript.Shell; %%Shortcut = %%WshShell.CreateShortcut('%%USERPROFILE%%\Desktop\BED with Tab Panel.lnk'); %%Shortcut.TargetPath = '%%APPDATA%%\BED\bed-with-tab-panel.exe'; %%Shortcut.Save()^^"
echo.
echo REM Add to PATH ^(optional^)
echo Adding to PATH...
echo setx PATH "%%PATH%%;%%APPDATA%%\BED" /M
echo.
echo Installation complete!
echo You can now run BED with Tab Panel from your desktop or start menu.
echo pause
) > "dist\install.bat"

echo.
echo ========================================
echo Build completed successfully! 
echo ========================================
echo.
echo Output files created in dist\:
echo   - bed-with-tab-panel.exe  ^(Main executable^)
echo   - install.bat             ^(Windows installer^)
echo   - README.txt              ^(Documentation^)
echo.
echo To install:
echo   1. Run dist\install.bat on Windows
echo   2. Or directly run bed-with-tab-panel.exe
echo.
echo Press any key to open the dist folder...
pause >nul
explorer dist