@echo off
echo ==========================================
echo   🚀 QHSE App Launcher
echo   تشغيل تطبيق QHSE
echo ==========================================
echo.

REM Try to find Flutter in common locations
set FLUTTER_CMD=

if exist "C:\src\flutter\bin\flutter.bat" (
    set FLUTTER_CMD=C:\src\flutter\bin\flutter.bat
    echo ✅ Found Flutter at C:\src\flutter
) else if exist "C:\flutter\bin\flutter.bat" (
    set FLUTTER_CMD=C:\flutter\bin\flutter.bat
    echo ✅ Found Flutter at C:\flutter
) else if exist "%USERPROFILE%\flutter\bin\flutter.bat" (
    set FLUTTER_CMD=%USERPROFILE%\flutter\bin\flutter.bat
    echo ✅ Found Flutter at %USERPROFILE%\flutter
) else (
    REM Try using flutter from PATH
    where flutter >nul 2>&1
    if %errorlevel% equ 0 (
        set FLUTTER_CMD=flutter
        echo ✅ Found Flutter in PATH
    ) else (
        echo.
        echo ❌ ERROR: Could not find Flutter!
        echo.
        echo Please ensure Flutter is installed and either:
        echo   1. Add Flutter to your PATH, OR
        echo   2. Install Flutter to one of these locations:
        echo      - C:\src\flutter
        echo      - C:\flutter
        echo      - %USERPROFILE%\flutter
        echo.
        pause
        exit /b 1
    )
)

echo.
echo [1/2] Checking available devices...
echo.
call "%FLUTTER_CMD%" devices

echo.
echo [2/2] Starting app...
echo.
echo Choose device:
echo   1. Android Emulator
echo   2. Chrome (Web)
echo   3. Windows Desktop
echo   4. Let Flutter choose
echo.
set /p device_choice="Enter choice (1-4): "

if "%device_choice%"=="1" (
    echo Starting on Android emulator...
    call "%FLUTTER_CMD%" run
) else if "%device_choice%"=="2" (
    echo Starting on Chrome...
    call "%FLUTTER_CMD%" run -d chrome
) else if "%device_choice%"=="3" (
    echo Starting on Windows Desktop...
    call "%FLUTTER_CMD%" run -d windows
) else (
    echo Starting app (Flutter will choose device)...
    call "%FLUTTER_CMD%" run
)

pause
