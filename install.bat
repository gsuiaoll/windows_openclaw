@echo off
setlocal enabledelayedexpansion

REM OpenClaw Windows Installation Script
REM This script sets up OpenClaw for Windows

set "SCRIPT_DIR=%~dp0"
set "OPENCLAW_ROOT=%SCRIPT_DIR%"

echo ========================================
echo OpenClaw Windows Installation
echo ========================================
echo.

REM Set UTF-8 encoding
chcp 65001 > nul 2>&1

REM Check Node.js
where node > nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Node.js is not installed!
    echo Please install Node.js v22.12.0 or higher from: https://nodejs.org/
    exit /b 1
)

for /f "tokens=2" %%i in ('node -v 2^>nul') do set "NODE_VERSION=%%i"
echo [OK] Node.js detected: v!NODE_VERSION!

REM Check pnpm
where pnpm > nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [WARNING] pnpm is not installed
    echo Installing pnpm globally...
    call npm install -g pnpm
    if !ERRORLEVEL! neq 0 (
        echo [ERROR] Failed to install pnpm
        exit /b 1
    )
)

for /f "tokens=3" %%i in ('pnpm -v 2^>nul') do set "PNPM_VERSION=%%i"
echo [OK] pnpm detected: v!PNPM_VERSION!

REM Install dependencies
echo.
echo Installing dependencies...
call pnpm install --ignore-scripts
if !ERRORLEVEL! neq 0 (
    echo [ERROR] Failed to install dependencies
    exit /b 1
)

REM Build OpenClaw
echo.
echo Building OpenClaw...
call pnpm build
if !ERRORLEVEL! neq 0 (
    echo [ERROR] Build failed
    exit /b 1
)

REM Create config directory
set "OPENCLAW_HOME=%USERPROFILE%\.openclaw"
if not exist "%OPENCLAW_HOME%" (
    mkdir "%OPENCLAW_HOME%"
    echo Created config directory: %OPENCLAW_HOME%
)

REM Add firewall rule (optional)
echo.
set /p ADD_FIREWALL="Add Windows Firewall rule for OpenClaw Gateway? (Y/N): "
if /i "!ADD_FIREWALL!"=="Y" (
    call "%SCRIPT_DIR%scripts\add-firewall-rule.bat"
)

REM Install service (optional)
echo.
set /p INSTALL_SERVICE="Install OpenClaw to start automatically on login? (Y/N): "
if /i "!INSTALL_SERVICE!"=="Y" (
    call "%SCRIPT_DIR%scripts\install-service.bat"
)

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo To start OpenClaw, run:
echo   openclaw.cmd
echo   OR
echo   node openclaw.mjs
echo.
echo Configuration directory: %OPENCLAW_HOME%
echo.
echo For more information, see: docs/index.md
echo ========================================

pause
