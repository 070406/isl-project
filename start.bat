@echo off
cd /d "%~dp0"

python --version >nul 2>&1
if errorlevel 1 (
  echo  ERROR: Python not found. Run install.bat after installing Python.
  pause
  exit /b 1
)

echo.
echo  Signova
echo  Server: http://127.0.0.1:8000
echo.
echo  First time? Run install.bat once before this.
echo  Opening browser in ~15s. Keep this window open.
echo.

start "" cmd /c "ping -n 16 127.0.0.1 >nul & start http://127.0.0.1:8000/"

python run_server.py
pause
