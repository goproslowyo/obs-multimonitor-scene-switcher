@echo off
setlocal enabledelayedexpansion

:: Set version
set "PYTHON_VERSION=3.13.5"
set "PYTHON_INSTALLER=python-%PYTHON_VERSION%-amd64.exe"
set "PYTHON_URL=https://www.python.org/ftp/python/%PYTHON_VERSION%/%PYTHON_INSTALLER%"
set "PYTHON_EXE=%LOCALAPPDATA%\Programs\Python\Python313\python.exe"

:: Step 1: Check if a real Python is installed (not MS Store stub)
set "PYTHON_FOUND="

for /f "delims=" %%P in ('where python 2^>nul') do (

    echo %%P | findstr /i "WindowsApps" >nul
    if !errorlevel! neq 0 (
        set "PYTHON_FOUND=1"
    )
)

:: Step 2: Install Python if not found
if not defined PYTHON_FOUND (
    echo No valid Python installation found. Installing Python %PYTHON_VERSION%...
    echo Downloading from: %PYTHON_URL%
    curl -L -o "%PYTHON_INSTALLER%" "%PYTHON_URL%"
    if %errorlevel% neq 0 (
        echo Failed to download Python installer.
        pause
        exit /b 1
    )

    echo Installing Python silently...
    "%PYTHON_INSTALLER%" /quiet InstallAllUsers=0 PrependPath=1 Include_test=0 Include_launcher=1

    timeout /t 30 >nul
    del  "%PYTHON_INSTALLER%"
)

:: Step 3: Confirm Python now works
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo Python install failed or not on PATH. Please install manually: https://www.python.org/downloads/
    pause
    exit /b 1
)

:: Step 4: Create venv if missing
if not exist venv (
    echo Creating virtual environment...
    python -m venv venv
)

:: Step 5: Activate venv
call venv\Scripts\activate

:: Step 6: Install dependencies if not already marked
if not exist venv\.deps_installed (
    echo Installing dependencies...
    %PYTHON_EXE% -m pip install --upgrade pip
    %PYTHON_EXE% -m pip install -r requirements.txt
    echo ok > venv\.deps_installed
) else (
    echo Dependencies already installed. Skipping.
)

:: Step 7: Run the actual script
echo Starting OBS scene switcher... Press CTRL+C to stop script or close window.
%PYTHON_EXE% main.py

pause
