@echo off
chcp 65001 >nul 2>&1
REM TUILiveKit Manager - Modify SDK_APP_ID and SECRET_KEY in server .env
REM Usage: setup_server_env.bat <project_root> <sdk_app_id> <secret_key>

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Error: project root path is required
    echo Usage: setup_server_env.bat ^<project_root^> ^<sdk_app_id^> ^<secret_key^>
    exit /b 1
)
if "%~2"=="" (
    echo Error: SDK_APP_ID is required
    exit /b 1
)
if "%~3"=="" (
    echo Error: SECRET_KEY is required
    exit /b 1
)

set "PROJECT_ROOT=%~1"
set "SDK_APP_ID=%~2"
set "SECRET_KEY=%~3"
set "ENV_FILE=%PROJECT_ROOT%\packages\server\config\.env"

if not exist "%ENV_FILE%" (
    echo Error: .env file not found: %ENV_FILE%
    exit /b 1
)

REM Create a temp file with updated content
set "TEMP_FILE=%ENV_FILE%.tmp"

(
    for /f "usebackq tokens=1,* delims==" %%a in ("%ENV_FILE%") do (
        if "%%a"=="SDK_APP_ID" (
            echo SDK_APP_ID=%SDK_APP_ID%
        ) else if "%%a"=="SECRET_KEY" (
            echo SECRET_KEY=%SECRET_KEY%
        ) else (
            if "%%b"=="" (
                echo %%a
            ) else (
                echo %%a=%%b
            )
        )
    )
) > "%TEMP_FILE%"

move /y "%TEMP_FILE%" "%ENV_FILE%" >nul
echo Server .env updated: SDK_APP_ID and SECRET_KEY configured
echo    File: %ENV_FILE%

endlocal
