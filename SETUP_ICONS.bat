@echo off
echo ==========================================
echo      QHSE App - Icon Setup Script
echo ==========================================
echo.
echo [1/2] Updating dependencies...
call flutter pub get

echo.
echo [2/2] Generating App Icons...
call dart run flutter_launcher_icons

echo.
echo ==========================================
echo ✅ Setup Complete!
echo You can now run the app to see the new icon.
echo ==========================================
pause
