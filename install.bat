@echo off
setlocal enabledelayedexpansion

echo ================================
echo     VocabPy Windows Installer
echo ================================
echo.

:: -------------------------------------------------------
set REQ_URL=https://raw.githubusercontent.com/46Dimensions/VocabPy/main/requirements.txt
set SCRIPT_URL=https://raw.githubusercontent.com/46Dimensions/VocabPy/main/main.py
set SCRIPT_NAME=main.py
:: -------------------------------------------------------

:: Function to download a file (curl > powershell fallback)
echo Checking for curl...
curl --version >nul 2>&1
if %ERRORLEVEL%==0 (
    echo curl found — downloading files...
    curl -fsSL %REQ_URL% -o requirements.txt
    curl -fsSL %SCRIPT_URL% -o %SCRIPT_NAME%
) else (
    echo curl not found — using PowerShell downloader...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('%REQ_URL%', 'requirements.txt')"
    powershell -Command "(New-Object Net.WebClient).DownloadFile('%SCRIPT_URL%', '%SCRIPT_NAME%')"
)

echo.
echo Creating virtual environment...
python -m venv venv

:: Pick correct Python path
if exist venv\Scripts\python.exe (
    set PY=venv\Scripts\python.exe
) else (
    echo ERROR: Could not find Python in venv.
    exit /b 1
)

echo Upgrading pip...
"%PY%" -m pip install --upgrade pip

echo Installing dependencies...
"%PY%" -m pip install -r requirements.txt

echo.
echo ================================
echo    Installation complete!
echo    Launching VocabPy...
echo ================================
echo.

"%PY%" "%SCRIPT_NAME%"

echo.
echo Done!
echo To run VocabPy again next time:
echo   venv\Scripts\activate
echo   python main.py

endlocal
