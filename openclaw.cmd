@echo off
setlocal enabledelayedexpansion

REM OpenClaw Windows Launcher
REM This script handles Windows-specific startup requirements

REM Set UTF-8 encoding for proper Unicode support
chcp 65001 > nul 2>&1

REM Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"
set "OPENCLAW_ROOT=%SCRIPT_DIR%"

REM Check if Node.js is available
where node > nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Node.js is not installed or not in PATH
    echo Please install Node.js v22.12.0 or higher from https://nodejs.org/
    exit /b 1
)

REM Check Node.js version
for /f "tokens=2" %%i in ('node -v 2^>nul') do set "NODE_VERSION=%%i"
for /f "tokens=1 delims=." %%i in ('echo !NODE_VERSION:~1!') do set "NODE_MAJOR=%%i"
for /f "tokens=2 delims=." %%i in ('echo !NODE_VERSION:~1!') do set "NODE_MINOR=%%i"

if !NODE_MAJOR! LSS 22 (
    echo [ERROR] Node.js v22.12.0+ is required (current: v!NODE_VERSION!)
    echo Please upgrade Node.js from https://nodejs.org/
    exit /b 1
)

if !NODE_MAJOR! EQU 22 (
    if !NODE_MINOR! LSS 12 (
        echo [ERROR] Node.js v22.12.0+ is required (current: v!NODE_VERSION!)
        echo Please upgrade Node.js from https://nodejs.org/
        exit /b 1
    )
)

REM Set up environment variables
set "OPENCLAW_HOME=%USERPROFILE%\.openclaw"
set "OPENCLAW_STATE_DIR=%OPENCLAW_HOME%"
set "OPENCLAW_CONFIG_PATH=%OPENCLAW_HOME%\openclaw.json"

REM Create config directory if it doesn't exist
if not exist "%OPENCLAW_HOME%" (
    mkdir "%OPENCLAW_HOME%"
    echo Created OpenClaw config directory: %OPENCLAW_HOME%
)

REM Check if dist directory exists, if not, build first
if not exist "%OPENCLAW_ROOT%\dist\entry.js" (
    echo [INFO] Building OpenClaw for the first time...
    call node "%OPENCLAW_ROOT%\scripts\tsdown-build.mjs"
    if %ERRORLEVEL% neq 0 (
        echo [ERROR] Build failed
        exit /b 1
    )
)

REM Launch OpenClaw
node "%OPENCLAW_ROOT%\openclaw.mjs" %*
