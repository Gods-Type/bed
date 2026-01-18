@echo off
echo Creating ZIP package for easy download...

REM Create download directory
if not exist "download-package" mkdir download-package

REM Copy essential files to download package
echo Copying files...
copy "BED-Tab-Panel-Installer-Ready.exe" "download-package\" >nul
copy "Install-Tab-Panel.bat" "download-package\" >nul  
copy "Install-Tab-Panel.ps1" "download-package\" >nul

REM Create simple instructions
(
echo BED Tab Panel - Installation Files
echo ====================================
echo.
echo Choose ONE of these installation methods:
echo.
echo METHOD 1 - .exe Installer (Recommended):
echo ------------------------------------
echo Run: BED-Tab-Panel-Installer-Ready.exe
echo   - Professional installer with beautiful UI
echo   - Auto-detects Zed
echo   - One-click installation
echo.
echo METHOD 2 - Batch File:
echo --------------------
echo Run: Install-Tab-Panel.bat
echo   - Simple batch installer
echo   - Very basic, should work on all systems
echo   - Text-based interface
echo.
echo METHOD 3 - PowerShell:
echo --------------------
echo Right-click: Install-Tab-Panel.ps1 → Run with PowerShell
echo   - Modern PowerShell installer
echo   - Colored output and progress
echo   - Alternative if .exe doesn't work
echo.
echo TROUBLESHOOTING:
echo =================
echo.
echo If .exe doesn't work:
echo 1. Try the batch file (Install-Tab-Panel.bat)
echo 2. Try PowerShell (Install-Tab-Panel.ps1)
echo 3. Right-click and "Run as administrator"
echo 4. Check Windows Defender isn't blocking files
echo.
echo After installation:
echo 1. Restart Zed
echo 2. Settings → Extensions → Enable "bed-tab-panel"
echo 3. View → Tab Panel to see your new panel!
echo.
echo Need help? Check: https://github.com/your-repo/bed
) > "download-package\INSTALL.txt"

echo ZIP package created in: download-package\
echo.
echo Contents:
dir download-package

echo.
echo Users can download the entire 'download-package' folder!
echo It contains multiple installation options for maximum compatibility.
pause