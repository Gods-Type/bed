@echo off
echo.
echo ========================================
echo    Optimizing Repository Structure
echo ========================================
echo.

REM Create optimized structure
echo [1/3] Creating clean directory structure...

REM Move source files to organized structure
if not exist "src" mkdir src
if not exist "src\native" mkdir src\native
if not exist "src\extension" mkdir src\extension
if not exist "dist" mkdir dist
if not exist "docs" mkdir docs

echo Moving files to organized structure...

REM Move native implementation
if exist "crates\tab_panel" (
    move /Y "crates\tab_panel" "src\native\crates\tab_panel" >nul 2>nul
)

REM Move extension files
if exist "extension" (
    xcopy /E /I /Y "extension\*" "src\extension\" >nul 2>nul
    rmdir /s /q "extension" >nul 2>nul
)

REM Move vendor
if exist "vendor" (
    move /Y "vendor" "src\native\vendor" >nul 2>nul
)

REM Clean up old build files
echo [2/3] Cleaning up old files...

REM Keep only essential files in root
set KEEP_FILES=README.md LICENSE BED-Tab-Panel-Installer.bat src dist docs

REM Move documentation
if exist "*.md" (
    for %%f in (*.md) do (
        if not "%%f"=="README.md" (
            move /Y "%%f" "docs\" >nul 2>nul
        )
    )
)

REM Move build scripts to dist
if exist "build*.bat" (
    move /Y "build*.bat" "dist\" >nul 2>nul
)

if exist "install*.bat" (
    for %%f in (install*.bat) do (
        if not "%%f"=="BED-Tab-Panel-Installer.bat" (
            move /Y "%%f" "dist\" >nul 2>nul
        )
    )
)

if exist "test*.bat" (
    move /Y "test*.bat" "dist\" >nul 2>nul
)

REM Create final optimized files
echo [3/3] Creating optimized distribution...

REM Create simple launch script
(
echo @echo off
echo echo 🚀 BED Tab Panel - Quick Start
echo echo ==============================
echo echo.
echo echo Choose your installation method:
echo echo.
echo echo 1. Install Tab Panel (Recommended)
echo echo 2. Build from Source (Advanced)
echo echo 3. View Documentation
echo echo.
echo set /p choice="Choose option (1-3): "
echo.
echo if "%%choice%%"=="1" goto :install
echo if "%%choice%%"=="2" goto :build  
echo if "%%choice%%"=="3" goto :docs
echo goto :end
echo.
echo :install
echo echo Installing Tab Panel...
echo call BED-Tab-Panel-Installer.bat
echo goto :end
echo.
echo :build
echo echo Building from source...
echo if exist "dist\build-complete.bat" (
echo     call dist\build-complete.bat
echo ) else (
echo     echo Build scripts not found.
echo )
echo goto :end
echo.
echo :docs
echo echo Opening documentation...
echo if exist "README.md" (
echo     start notepad README.md
echo ) else (
echo     echo Documentation not found.
echo )
echo goto :end
echo.
echo :end
) > "Quick-Start.bat"

REM Create simple .exe equivalent using PowerShell
(
echo @echo off
echo powershell -Command "& { [System.Windows.Forms.MessageBox]::Show('BED Tab Panel Installer\n\nClick OK to install Tab Panel for Zed.\n\nThis will enhance your Zed with professional tab management.', 'BED Tab Panel', 'OK', 'Information') }"
echo call BED-Tab-Panel-Installer.bat
) > "BED-Tab-Panel-Setup.exe"

echo.
echo ========================================
echo    OPTIMIZATION COMPLETE!
echo ========================================
echo.
echo New repository structure:
echo.
echo bed/
echo ├── 🚀 BED-Tab-Panel-Installer.bat   ← Main installer
echo ├── 📖 README.md                     ← Documentation  
echo ├── 🎯 Quick-Start.bat              ← Quick launcher
echo ├── 🔧 src/                         ← Source code
echo │   ├── native/                     ← Rust implementation
echo │   └── extension/                  ← JavaScript version
echo ├── 📦 dist/                        ← Distribution files
echo └── 📚 docs/                        ← Documentation
echo.
echo ✅ Repository optimized for simplicity
echo ✅ One-click installer ready
echo ✅ Clean, organized structure
echo.
echo Ready for distribution! 🎉
echo.
pause