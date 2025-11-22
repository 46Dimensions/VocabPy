@echo off
setlocal ENABLEDELAYEDEXPANSION

:: Enable ANSI escape sequences for colors
for /f %%A in ('echo prompt $E ^| cmd') do set "ESC=%%A"
set "red=%ESC%[31m"
set "green=%ESC%[32m"
set "yellow=%ESC%[33m"
set "reset=%ESC%[0m"

echo %green%===============================%reset%
echo %green%    LexiconPro Windows Installer%reset%
echo %green%===============================%reset%
echo.

:: -------------------------------------------------------
set "BASE_URL=https://raw.githubusercontent.com/46Dimensions/LexiconPro/main"
set "REQ_URL=%BASE_URL%/requirements.txt"
set "MAIN_URL=%BASE_URL%/main.py"
set "CREATE_URL=%BASE_URL%/create_vocab_file.py"
:: -------------------------------------------------------

:: Check Python exists
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo %red%ERROR: Python not found. Please install Python 3.10+.%reset%
    exit /b 1
)

:: Extract version
for /f "tokens=2 delims= " %%v in ('python --version') do set "PYVER=%%v"
for /f "tokens=1-3 delims=." %%a in ("%PYVER%") do (
    set MAJOR=%%a
    set MINOR=%%b
)

if %MAJOR% LSS 3 (
    echo %red%ERROR: Python version too old.%reset%
    exit /b 1
)
if %MAJOR%==3 if %MINOR% LSS 10 (
    echo %red%ERROR: Python must be 3.10 or higher.%reset%
    exit /b 1
)

echo %yellow%Creating LexiconPro directory...%reset%
mkdir LexiconPro 2>nul

echo %yellow%Checking for curl...%reset%
curl --version >nul 2>&1
if %errorlevel%==0 (
    echo %green%curl found — downloading files...%reset%
    curl -fsSL "%REQ_URL%" -o "LexiconPro\requirements.txt" || (echo %red%Failed to download requirements.txt%reset% & exit /b 1)
    curl -fsSL "%MAIN_URL%" -o "LexiconPro\main.py" || (echo %red%Failed to download main.py%reset% & exit /b 1)
    curl -fsSL "%CREATE_URL%" -o "LexiconPro\create_vocab_file.py" || (echo %red%Failed to download create_vocab_file.py%reset% & exit /b 1)
) else (
    echo %yellow%curl not found — using PowerShell...%reset%
    powershell -NoLogo -Command "Invoke-WebRequest '%REQ_URL%' -OutFile 'LexiconPro\requirements.txt'" || (echo %red%Failed to download requirements.txt%reset% & exit /b 1)
    powershell -NoLogo -Command "Invoke-WebRequest '%MAIN_URL%' -OutFile 'LexiconPro\main.py'" || (echo %red%Failed to download main.py%reset% & exit /b 1)
    powershell -NoLogo -Command "Invoke-WebRequest '%CREATE_URL%' -OutFile 'LexiconPro\create_vocab_file.py'" || (echo %red%Failed to download create_vocab_file.py%reset% & exit /b 1)
)

:: Verify downloads
if not exist LexiconPro\requirements.txt (echo %red%ERROR: requirements.txt missing.%reset% & exit /b 1)
if not exist LexiconPro\main.py (echo %red%ERROR: main.py missing.%reset% & exit /b 1)
if not exist LexiconPro\create_vocab_file.py (echo %red%ERROR: create_vocab_file.py missing.%reset% & exit /b 1)

echo.
echo %yellow%Creating virtual environment...%reset%
python -m venv LexiconPro\venv || (echo %red%Failed to create venv%reset% & exit /b 1)

if exist LexiconPro\venv\Scripts\python.exe (
    set "PY=LexiconPro\venv\Scripts\python.exe"
) else (
    echo %red%ERROR: Could not find Python in venv.%reset%
    exit /b 1
)

echo %yellow%Upgrading pip...%reset%
"%PY%" -m pip install --upgrade pip || (echo %red%Failed to upgrade pip%reset% & exit /b 1)

echo %yellow%Installing dependencies...%reset%
"%PY%" -m pip install -r LexiconPro\requirements.txt || (echo %red%Failed to install dependencies%reset% & exit /b 1)

echo.
echo %green%===============================%reset%
echo %green%   Installation complete!%reset%
echo %green%   Launching LexiconPro...%reset%
echo %green%===============================%reset%
echo.

"%PY%" LexiconPro\main.py || (echo %red%ERROR: Failed to launch LexiconPro.%reset% & exit /b 1)

echo.
echo Done!
echo To run again:
echo   LexiconPro\venv\Scripts\python.exe LexiconPro\main.py

endlocal