@echo off
chcp 65001 >nul 2>&1
REM TUILiveKit Manager - Check if a port is in use
REM Usage: check_port.bat <port>
REM Exit code: 0 = port is free, 1 = port is occupied

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Error: port number is required
    echo Usage: check_port.bat ^<port^>
    exit /b 1
)

set "PORT=%~1"

REM Use netstat to check port
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%PORT% " ^| findstr "LISTENING" 2^>nul') do (
    set "PID=%%a"
)

if defined PID (
    REM Try to get process name
    for /f "tokens=1" %%b in ('tasklist /fi "PID eq %PID%" /fo csv /nh 2^>nul') do (
        set "PNAME=%%~b"
    )
    echo Warning: Port %PORT% is occupied by process: !PNAME! ^(PID: !PID!^)
    exit /b 1
) else (
    echo Port %PORT% is available
    exit /b 0
)

endlocal
