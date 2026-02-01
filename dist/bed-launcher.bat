@echo off
echo Starting BED with Tab Panel...
echo.
echo Looking for Zed installation...
echo.

if exist "%ProgramFiles%\Zed\zed.exe" (
    start "" "%ProgramFiles%\Zed\zed.exe"
) else if exist "%ProgramFiles(x86)%\Zed\zed.exe" (
    start "" "%ProgramFiles(x86)%\Zed\zed.exe"
) else if exist "%LOCALAPPDATA%\Zed\zed.exe" (
    start "" "%LOCALAPPDATA%\Zed\zed.exe"
) else if exist "%APPDATA%\Zed\zed.exe" (
    start "" "%APPDATA%\Zed\zed.exe"
) else (
    echo Zed not found. Please install from https://zed.dev
    echo.
    start https://zed.dev
)
