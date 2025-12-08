@echo off
echo ================================================
echo   QHSE Flutter App - Setup and Run Script
echo   نظام إدارة مخالفات QHSE
echo ================================================
echo.

REM Check if Flutter is installed
echo [1/4] Checking Flutter installation...
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ❌ ERROR: Flutter is not installed!
    echo.
    echo Please install Flutter first:
    echo 1. Download from: https://docs.flutter.dev/get-started/install/windows
    echo 2. Extract to C:\src\flutter
    echo 3. Add C:\src\flutter\bin to PATH
    echo 4. Restart your computer
    echo 5. Run this script again
    echo.
    echo For detailed instructions, see INSTALLATION_GUIDE.md
    echo.
    pause
    exit /b 1
)

echo ✅ Flutter is installed!
echo.

REM Get Flutter packages
echo [2/4] Installing dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo.
    echo ❌ ERROR: Failed to install dependencies
    pause
    exit /b 1
)

echo ✅ Dependencies installed!
echo.

REM Check available devices
echo [3/4] Checking available devices...
call flutter devices

echo.
echo [4/4] Ready to run!
echo.
echo Choose how to run the app:
echo   1. Chrome (Web) - Easiest, no emulator needed
echo   2. Windows Desktop
echo   3. Show all devices
echo   4. Exit
echo.

set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" (
    echo.
    echo Starting app on Chrome...
    call flutter run -d chrome
) else if "%choice%"=="2" (
    echo.
    echo Starting app on Windows Desktop...
    call flutter run -d windows
) else if "%choice%"=="3" (
    echo.
    call flutter run
) else (
    echo.
    echo Exiting...
    exit /b 0
)

pause
