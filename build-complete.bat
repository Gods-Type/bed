@echo off
setlocal enabledelayedexpansion

echo.
echo ========================================
echo    Building BED with Tab Panel
echo ========================================
echo.

set BUILD_START_TIME=%time%
set BUILD_SUCCESS=0

REM Step 1: Environment Check
echo [1/6] Checking environment...
call :check_prerequisites
if !BUILD_SUCCESS!==0 goto :error

REM Step 2: Clean previous builds  
echo [2/6] Cleaning previous builds...
if exist "vendor\zed\target" (
    rmdir /s /q "vendor\zed\target" >nul 2>nul
)
echo Previous builds cleaned.

REM Step 3: Update dependencies (optional but recommended)
echo [3/6] Updating dependencies...
cd vendor\zed
echo Running cargo check...
cargo check --package tab_panel
if !ERRORLEVEL! NEQ 0 (
    echo WARNING: Tab Panel check failed, continuing with build...
)

REM Step 4: Build the project
echo [4/6] Compiling Zed with Tab Panel...
echo This may take 10-20 minutes on first build...
echo.

REM Try to build in release mode
cargo build --release --bin zed
if !ERRORLEVEL! NEQ 0 (
    echo ERROR: Release build failed!
    echo.
    echo Trying debug build for testing...
    cargo build --bin zed
    if !ERRORLEVEL! NEQ 0 (
        echo ERROR: Debug build also failed!
        goto :error
    ) else (
        echo Debug build successful!
        set BUILD_TYPE=debug
    )
) else (
    echo Release build successful!
    set BUILD_TYPE=release
)

cd ..\..

REM Step 5: Create distributable
echo [5/6] Creating distributable package...
call :create_package
if !BUILD_SUCCESS!==0 goto :error

REM Step 6: Create installer
echo [6/6] Creating installer...
call :create_installer
if !BUILD_SUCCESS!==0 goto :error

REM Success
call :success
goto :end

:error
echo.
echo ========================================
echo    BUILD FAILED
echo ========================================
echo.
echo Please check the error messages above.
echo Common issues:
echo 1. Rust not installed - install from https://rustup.rs/
echo 2. Missing dependencies - run 'cargo update' first
echo 3. Insufficient disk space
echo 4. Antivirus blocking compilation
echo.
echo For help, please check the build logs.
goto :end

:success
set BUILD_END_TIME=%time%
echo.
echo ========================================
echo    BUILD SUCCESSFUL!
echo ========================================
echo.
echo Build completed in: !BUILD_START_TIME! - !BUILD_END_TIME!
echo.
echo Output files in dist\:
dir /b dist\
echo.
echo Installation options:
echo 1. Run dist\install.bat for automatic installation
echo 2. Run dist\bed-with-tab-panel.exe directly
echo 3. Use the portable version from dist\portable\
echo.

goto :end

:check_prerequisites
where cargo >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Rust/Cargo not found!
    echo Please install Rust from: https://rustup.rs/
    set BUILD_SUCCESS=1
    goto :eof
)

if not exist "vendor\zed\crates\tab_panel" (
    echo ERROR: Tab Panel source not found!
    echo Please ensure the tab_panel module is in vendor\zed\crates\
    set BUILD_SUCCESS=1
    goto :eof
)

echo Environment check passed.
goto :eof

:create_package
if not exist "dist" mkdir dist

REM Copy executable based on build type
if "%BUILD_TYPE%"=="release" (
    copy "vendor\zed\target\release\zed.exe" "dist\bed-with-tab-panel.exe" >nul
) else (
    copy "vendor\zed\target\debug\zed.exe" "dist\bed-with-tab-panel.exe" >nul
)

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to copy executable!
    set BUILD_SUCCESS=1
    goto :eof
)

REM Copy resources
if exist "vendor\zed\crates\zed\resources" (
    xcopy /E /I /Y "vendor\zed\crates\zed\resources" "dist\resources" >nul
)

REM Create portable directory
if not exist "dist\portable" mkdir "dist\portable"
copy "dist\bed-with-tab-panel.exe" "dist\portable\" >nul
if exist "dist\resources" xcopy /E /I /Y "dist\resources" "dist\portable\resources" >nul

REM Create README
(
echo BED with Tab Panel - Version 1.0
echo =====================================
echo.
echo A custom build of Zed editor with Tab Panel functionality.
echo.
echo Features:
echo ✓ All standard Zed editor features
echo ✓ New Tab Panel for managing open tabs
echo ✓ Accessible via View menu -^> Tab Panel
echo ✓ Tab Panel appears beside Project Panel
echo ✓ Search functionality (coming soon)
echo ✓ Right-click context menus (coming soon)
echo ✓ Ctrl-Shift-T shortcuts (coming soon)
echo.
echo Installation:
echo =============
echo.
echo Option 1 - Automatic Installation:
echo   Run install.bat to install to AppData
echo.
echo Option 2 - Portable:
echo   Run portable\bed-with-tab-panel.exe directly
echo   No installation required
echo.
echo Option 3 - Manual:
echo   Copy bed-with-tab-panel.exe to any location
echo   Run it directly
echo.
echo Usage:
echo =====
echo.
echo To toggle Tab Panel:
echo   - Go to View -^> Tab Panel
echo   - Use Command Palette: "Tab Panel"
echo   - Keyboard shortcut: Coming soon
echo.
echo The Tab Panel shows all open tabs in a hierarchical view,
echo making it easier to manage multiple files and projects.
echo.
echo System Requirements:
echo ====================
echo - Windows 10 or later
echo - 2GB RAM minimum
echo - 500MB disk space
echo.
echo Troubleshooting:
echo ================
echo If the Tab Panel doesn't appear:
echo   1. Check that View -^> Tab Panel is enabled
echo   2. Restart the editor
echo   3. Check the console for errors
echo.
echo For support and updates:
echo https://github.com/your-repo/bed
echo.
echo Build Information:
echo =================
echo Build Type: %BUILD_TYPE%
echo Build Date: %date%
echo Tab Panel Version: 1.0
echo Based on Zed Editor
) > "dist\README.txt"

echo Package created successfully.
goto :eof

:create_installer
REM Create Windows installer
(
echo @echo off
echo.
echo BED with Tab Panel - Installer
echo ==============================
echo.
echo Installing to: %%APPDATA%%\BED
echo.

REM Create directory
if not exist "%%APPDATA%%\BED" mkdir "%%APPDATA%%\BED"

REM Copy files
echo Copying files...
copy "bed-with-tab-panel.exe" "%%APPDATA%%\BED\" >nul
if exist "resources" xcopy /E /I /Y "resources" "%%APPDATA%%\BED\resources\" >nul

REM Create desktop shortcut
echo Creating desktop shortcut...
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%USERPROFILE%\Desktop\BED with Tab Panel.lnk'); $Shortcut.TargetPath = '%APPDATA%\BED\bed-with-tab-panel.exe'; $Shortcut.WorkingDirectory = '%APPDATA%\BED'; $Shortcut.IconLocation = '%APPDATA%\BED\bed-with-tab-panel.exe,0'; $Shortcut.Description = 'BED with Tab Panel - Enhanced Zed Editor'; $Shortcut.Save()"

REM Add to PATH
echo Adding to system PATH...
for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH 2^>nul') do set "system_path=%%b"
echo !system_path! | findstr /i /c:"%%APPDATA%%\BED" >nul
if errorlevel 1 (
    setx PATH "!PATH!;%%APPDATA%%\BED" /M >nul
    echo Added to system PATH.
) else (
    echo Already in PATH.
)

REM Create Start Menu shortcut
echo Creating Start Menu shortcut...
if not exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\BED" mkdir "%APPDATA%\Microsoft\Windows\Start Menu\Programs\BED"
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%APPDATA%\Microsoft\Windows\Start Menu\Programs\BED\BED with Tab Panel.lnk'); $Shortcut.TargetPath = '%APPDATA%\BED\bed-with-tab-panel.exe'; $Shortcut.WorkingDirectory = '%APPDATA%\BED'; $Shortcut.Description = 'BED with Tab Panel'; $Shortcut.Save()"

echo.
echo Installation completed successfully!
echo.
echo You can now run BED with Tab Panel from:
echo - Desktop shortcut
echo - Start Menu
echo - Command line: bed-with-tab-panel
echo.
echo Press any key to start the application...
pause >nul
start "" "%%APPDATA%%\BED\bed-with-tab-panel.exe"
) > "dist\install.bat"

echo Installer created successfully.
goto :eof

:end
echo.
echo Press any key to open the dist folder...
pause >nul
explorer dist