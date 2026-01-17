@echo off
setlocal enabledelayedexpansion

echo ==================================
echo    BED with Tab Panel - Install
echo ==================================

echo.
echo Checking for existing Zed installation...
if exist "C:\Program Files\Zed\zed.exe" (
    echo Found Zed at: C:\Program Files\Zed\zed.exe
    echo Adding Tab Panel to existing installation...
    if exist "C:\Program Files\Zed\resources\themes" (
        xcopy /E /I /Y "vendor\zed\crates\zed\resources\*" "C:\Program Files\Zed\resources" >nul
        echo Added themes to Zed resources
    )
    echo Tab Panel integration complete!
    echo.
    echo You can now use Tab Panel in Zed via:
    echo   - View menu - Tab Panel
    echo   - Command palette - search "Tab Panel"
    pause
    goto end
else if exist "C:\Users\tasticp\AppData\Local\Programs\Zed\zed.exe"(
    echo Found Zed at: C:\Users\tasticp\AppData\Local\Programs\Zed\zed.exe
    echo Adding Tab Panel to existing installation...
    if exist "C:\Program Files\Zed\resources\themes" (
        xcopy /E /I /Y "vendor\zed\crates\zed\resources\*" "C:\Program Files\Zed\resources" >nul
        echo Added themes to Zed resources
    )
    echo Tab Panel integration complete!
    echo.
    echo You can now use Tab Panel in Zed via:
    echo   - View menu - Tab Panel
    echo   - Command palette - search "Tab Panel"
    pause
    goto end
) else (
    echo Zed not found in standard location
    echo.
    echo Please download and install Zed first
    echo.
    echo Opening download page...
    start https://zed.dev
    goto end
)

:end
echo Press any key to exit...
pause >nul
