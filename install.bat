@echo off
cd /d "%~dp0"

echo.
echo  Signova - Installing Python dependencies...
echo.

python --version >nul 2>&1
if errorlevel 1 (
  echo  ERROR: Python not found. Install Python 3.10+ and add it to PATH.
  echo  https://www.python.org/downloads/
  pause
  exit /b 1
)

python -m pip install --upgrade pip
python -m pip install -r requirements.txt

if errorlevel 1 (
  echo.
  echo  Install failed. Check your internet connection and try again.
  pause
  exit /b 1
)

echo.
echo  Dependencies installed. Double-click start.bat to run Signova.
echo.
pause
