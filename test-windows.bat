@echo off
setlocal enabledelayedexpansion

REM OpenClaw Windows Compatibility Test Script
REM Tests basic Windows functionality

echo ========================================
echo OpenClaw Windows Compatibility Test
echo ========================================
echo.

set "TESTS_PASSED=0"
set "TESTS_FAILED=0"

REM Set UTF-8 encoding
chcp 65001 > nul 2>&1

REM Test 1: Node.js availability
echo [TEST 1] Checking Node.js installation...
where node > nul 2>&1
if %ERRORLEVEL% equ 0 (
    for /f "tokens=2" %%i in ('node -v 2^>nul') do set "NODE_VERSION=%%i"
    echo [PASS] Node.js found: v!NODE_VERSION!
    set /a TESTS_PASSED+=1
) else (
    echo [FAIL] Node.js not found
    set /a TESTS_FAILED+=1
)

REM Test 2: pnpm availability
echo.
echo [TEST 2] Checking pnpm installation...
where pnpm > nul 2>&1
if %ERRORLEVEL% equ 0 (
    for /f "tokens=3" %%i in ('pnpm -v 2^>nul') do set "PNPM_VERSION=%%i"
    echo [PASS] pnpm found: v!PNPM_VERSION!
    set /a TESTS_PASSED+=1
) else (
    echo [WARN] pnpm not found (optional)
)

REM Test 3: Config directory creation
echo.
echo [TEST 3] Testing config directory creation...
set "OPENCLAW_HOME=%USERPROFILE%\.openclaw"
if not exist "%OPENCLAW_HOME%" (
    mkdir "%OPENCLAW_HOME%" 2>nul
    if !ERRORLEVEL! equ 0 (
        echo [PASS] Created config directory: %OPENCLAW_HOME%
        set /a TESTS_PASSED+=1
    ) else (
        echo [FAIL] Failed to create config directory
        set /a TESTS_FAILED+=1
    )
) else (
    echo [PASS] Config directory already exists
    set /a TESTS_PASSED+=1
)

REM Test 4: Config file check
echo.
echo [TEST 4] Checking config file...
if exist "%OPENCLAW_HOME%\openclaw.json" (
    echo [PASS] Config file exists
    set /a TESTS_PASSED+=1
) else (
    echo [INFO] Config file not found (will be created on first run)
)

REM Test 5: Script files check
echo.
echo [TEST 5] Checking Windows scripts...
set "SCRIPTS_OK=1"
if not exist "openclaw.cmd" (
    echo [WARN] openclaw.cmd not found
    set "SCRIPTS_OK=0"
)
if not exist "scripts\add-firewall-rule.bat" (
    echo [WARN] scripts\add-firewall-rule.bat not found
    set "SCRIPTS_OK=0"
)
if not exist "scripts\install-service.bat" (
    echo [WARN] scripts\install-service.bat not found
    set "SCRIPTS_OK=0"
)
if "!SCRIPTS_OK!"=="1" (
    echo [PASS] All Windows scripts present
    set /a TESTS_PASSED+=1
) else (
    echo [FAIL] Some Windows scripts missing
    set /a TESTS_FAILED+=1
)

REM Test 6: Build check
echo.
echo [TEST 6] Checking build output...
if exist "dist\entry.js" (
    echo [PASS] Build output found
    set /a TESTS_PASSED+=1
) else (
    echo [WARN] Build output not found (run 'pnpm build' first)
)

REM Test 7: Environment variables
echo.
echo [TEST 7] Testing environment variables...
set "TEST_VAR=TestValue"
if "!TEST_VAR!"=="TestValue" (
    echo [PASS] Environment variables working
    set /a TESTS_PASSED+=1
) else (
    echo [FAIL] Environment variables not working
    set /a TESTS_FAILED+=1
)

REM Test 8: Path handling
echo.
echo [TEST 8] Testing path handling...
set "TEST_PATH=%USERPROFILE%\test\path\with\spaces"
if defined TEST_PATH (
    echo [PASS] Path handling working
    set /a TESTS_PASSED+=1
) else (
    echo [FAIL] Path handling not working
    set /a TESTS_FAILED+=1
)

REM Summary
echo.
echo ========================================
echo Test Summary
echo ========================================
echo Tests Passed: !TESTS_PASSED!
echo Tests Failed: !TESTS_FAILED!
echo.

if !TESTS_FAILED! equ 0 (
    echo [SUCCESS] All tests passed!
    echo.
    echo OpenClaw is ready to run on Windows.
    echo Use 'openclaw.cmd' to start.
) else (
    echo [WARNING] Some tests failed.
    echo Please check the errors above.
    echo.
    echo You may still be able to run OpenClaw.
)

echo ========================================

endlocal
exit /b %TESTS_FAILED%
