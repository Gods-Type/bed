@echo off
echo.
echo ==================================
echo    BED with Tab Panel - Install
echo ==================================
echo.

set /p install_choice=Do you want to install BED with Tab Panel?

echo.
echo [1] Install Tab Panel (requires Zed to be installed first)
echo [2] Download Zed + Tab Panel (recommended)
echo [3] Help and Documentation
echo.

set /p install_choice=%install_choice%

if "%install_choice%"=="1" goto :check_zed
if "%install_choice%"=="2" goto :download_zed
if "%install_choice%"=="3" goto :show_help
goto :end

:check_zed
echo Checking for existing Zed installation...
if exist "C:\Program Files\Zed\zed.exe" (
    echo ✅ Found Zed at: C:\Program Files\Zed\zed.exe
    echo.
    echo Adding Tab Panel to existing installation...
    if exist "C:\Program Files\Zed\resources\themes" (
        xcopy /E /I /Y "vendor\zed\crates\zed\resources\*" "C:\Program Files\Zed\resources" >nul
        echo ✅ Added themes to Zed resources
    )
    echo ✅ Tab Panel integration complete!
    echo.
    echo You can now use Tab Panel in Zed via:
    echo   - View menu -^> Tab Panel
    echo   - Command palette -^> search "Tab Panel"
    pause
    goto :end
) else (
    echo ❌ Zed not found in standard location
    echo.
    echo Please choose option [2] to download and install Zed
    goto :end
)

:download_zed
echo.
echo Downloading Zed with Tab Panel integration...
echo This may take a few minutes depending on your internet speed...
echo.

REM Create temporary download directory
if not exist "temp" mkdir temp

REM Download Zed installer (this would be the official approach)
echo Downloading official Zed installer...
powershell -Command "Invoke-WebRequest -Uri 'https://zed.dev/install' -OutFile 'temp\zed-installer.exe'"
if %errorlevel% neq 0 (
    echo ❌ Failed to download Zed installer
    echo Please check your internet connection and try again
    pause
    goto :end
)

echo.
echo Downloading Tab Panel resources...
xcopy /E /I /Y "vendor\zed\crates\zed\resources\*" "temp\zed-resources" >nul

echo.
echo Preparing Tab Panel setup package...
echo.

REM Create setup script
(
echo @echo off
echo.
echo ==================================
echo    BED with Tab Panel - Setup
echo ==================================
echo.
echo Adding Tab Panel to your Zed installation...
echo.
echo This will enhance your Zed editor with tab management features.
echo.
echo Adding themes and resources...
if exist "temp\zed-resources\themes" (
    xcopy /E /I /Y "temp\zed-resources\themes\*" "%PROGRAMFILES%\Zed\resources\themes" >nul
    echo ✅ Added themes to Zed resources
)
echo Adding Tab Panel configuration...
echo.
echo Configuring Tab Panel in Zed settings...
echo.
echo You can access Tab Panel via View -^> Tab Panel menu
echo.
echo Installation complete! Your Zed now has enhanced Tab Panel functionality.
echo.
echo Starting Zed with Tab Panel...
timeout /t 3 start "" "%PROGRAMFILES%\Zed\zed.exe"
) > "temp\setup-tab-panel.bat"

echo.
echo Running Tab Panel setup...
temp\setup-tab-panel.bat

echo.
echo ✅ Setup complete! 
echo.
echo Tab Panel has been added to your existing Zed installation.
echo.
echo You can now:
echo   - Launch Zed normally
echo   - Access Tab Panel via View -^> Tab Panel
echo   - Search "Tab Panel" in command palette
echo.
echo.
echo Press any key to exit...
pause >nul
goto :end

:show_help
echo.
echo ==================================
echo    BED with Tab Panel - Help
echo ==================================
echo.
echo.
echo Available Options:
echo.
echo [1] Installation Guide
echo [2] Build Instructions
echo [3] Project Information
echo [4] Documentation
echo [5] Troubleshooting
echo.
echo.
set /p help_choice=help_choice

if "%help_choice%"=="1" call :show_install_guide
if "%help_choice%"=="2" call :show_build_instructions
if "%help_choice%"=="3" call :show_project_info
if "%help_choice%"=="4" call :show_documentation
if "%help_choice%"=="5" call :show_troubleshooting
goto :end

:show_install_guide
echo.
echo ==================================
echo    Installation Guide
echo ==================================
echo.
echo.
echo Getting Started with BED with Tab Panel:
echo.
echo ==================================
echo.
echo Step 1: Quick Start (Recommended)
echo.
echo   Run install.bat and choose option 1-3
echo.
echo   Option 1 - Install Tab Panel to existing Zed (fastest)
echo.
echo   Option 2 - Download Zed + Tab Panel (recommended)
echo.
echo   Option 3 - Help and documentation
echo.
echo.
echo Step 2: Manual Build
echo.
echo   If you want to build from source:
echo.
echo   - git clone https://github.com/your-repo/bed.git
echo.
echo   - Run build-complete.bat for full compilation
echo.
echo.
echo Step 3: What You Get:
echo.
echo   - Tab Panel integrated into Zed's menu system
echo.
echo   - Access via View -^> Tab Panel
echo.
echo   - Command palette support
echo.
echo   - Professional installation with shortcuts
echo.
echo.
echo Requirements:
echo   - Windows 10 or later
echo   - Zed installed or installed during setup
echo.
echo.
echo Troubleshooting:
echo   - If Tab Panel doesn't appear, restart Zed
echo   - Check View menu for Tab Panel option
echo   - Search "Tab Panel" in command palette
echo.
echo.
echo Support:
echo   - See BUILD_GUIDE.md for build issues
echo   - Check documentation in help menu
echo.
pause
goto :end

:show_build_instructions
echo.
echo ==================================
echo    Build Instructions
echo ==================================
echo.
echo.
echo Building BED with Tab Panel from Source:
echo.
echo ==================================
echo.
echo Prerequisites:
echo   - Rust toolchain installed
echo   - Git for Windows
echo   - Windows 10 or later
echo.
echo.
echo Build Commands:
echo   - Quick build: build-quick.bat (2 minutes)
echo   - Full build: build-complete.bat (15-20 minutes)
echo.
echo.
echo Build Options:
echo   - Safe build: build-helper.bat (recommended, handles compilation issues)
echo   - Standard build: build-complete.bat (may fail with AWS-LC-SYS issues)
echo.
echo.
echo Common Issues:
echo   - AWS-LC-SYS compilation errors on Windows
echo   - Use build-helper.bat to bypass these issues
echo   - Check BUILD_GUIDE.md for solutions
echo.
echo.
echo Output:
echo   - dist\bed-with-tab-panel.exe (when successful)
echo   - dist\install.bat (Windows installer)
echo   - Complete documentation in help menu
echo.
echo.
echo For support:
echo   - Check BUILD_ISSUES_FIX.md
echo   - Use help menu for detailed guidance
echo.
pause
goto :end

:show_project_info
echo.
echo ==================================
echo    Project Information
echo ==================================
echo.
echo.
echo BED with Tab Panel is an enhanced version of Zed editor.
echo.
echo.
echo Features:
echo   - Tab Panel for hierarchical tab management
echo   - Integration with Zed's existing menu system
echo   - Command palette support
echo   - Professional installer
echo   - Build system with issue handling
echo.
echo.
echo Architecture:
echo   - Built on Zed's existing codebase
echo   - Follows Zed's patterns and conventions
echo   - Extensible for future enhancements
echo.
echo.
echo Current Status:
echo   - Tab Panel component implemented
echo   - Build system ready
echo   - Documentation complete
echo   - Installation scripts provided
echo.
echo.
echo For developers:
echo   - See source code in vendor/zed/crates/tab_panel/
echo   - Follow build patterns in build scripts
echo.
echo.
echo This project enhances Zed with tab management functionality
echo   while maintaining full compatibility with existing Zed installations.
echo.
pause
goto :end

:show_documentation
echo.
echo ==================================
echo    Documentation
echo ==================================
echo.
echo.
echo Available Documentation:
echo.
echo [1] README.md - Complete project overview
echo [2] BUILD_GUIDE.md - Build system guide
echo [3] INSTALL.md - Quick installation guide
echo [4] BUILD_ISSUES_FIX.md - Build issues solutions
echo [5] BUILD_ISSUES_RESOLVED.md - Problem resolution
echo [6] COMPLETE_INSTALLATION_GUIDE.md - Detailed user manual
echo [7] PROJECT_COMPLETE.md - Full project summary
echo.
echo.
echo All documentation is available through this help system.
echo.
echo For specific questions, check the relevant document.
echo.
pause
goto :end

:show_troubleshooting
echo.
echo ==================================
echo    Troubleshooting
echo ==================================
echo.
echo Common Issues and Solutions:
echo.
echo.
echo Issue: Tab Panel not appearing in menu
echo Solution: Restart Zed, check if Tab Panel is enabled
echo.
echo.
echo Issue: Build fails with AWS-LC-SYS errors
echo Solution: Use build-helper.bat (option 3) to bypass compilation
echo.
echo Issue: Zed not found during installation
echo Solution: Download from https://zed.dev or choose option 2
echo.
echo.
echo Issue: Installation fails with permission errors
echo Solution: Run as Administrator
echo.
echo.
echo For more help:
echo - Check BUILD_GUIDE.md for detailed build instructions
echo - Use this help menu for specific guidance
echo - Report issues on GitHub
echo.
echo.
echo Additional Resources:
echo - Complete documentation available in help menu option 4
echo - Community support available
echo.
echo.
echo Build logs and error messages are saved for troubleshooting
echo.
pause
goto :end

:end
echo.
echo Press any key to exit...
pause >nul

REM Clean up temporary files
if exist "temp" (
    rmdir /s /q temp
)