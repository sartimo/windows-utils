@echo off
setlocal enabledelayedexpansion

REM Get SID of the current user
for /f "tokens=2 delims=," %%a in ('whoami /user /fo csv ^| find "S-1-"') do set SID=%%a

:: this var stores current SID: !SID!

endlocal

@echo off
setlocal enabledelayedexpansion

REM Step 1: Create a shared drive on C:\
net share SharedDrive=C:\ /grant:everyone,full

REM Step 2: Create a new local user
set NEW_USERNAME=NewUser
set NEW_USER_PASSWORD=Password123

net user !NEW_USERNAME! !NEW_USER_PASSWORD! /add

REM Step 3: Export registry hive (ntuser.dat) of the new user to the shared drive
set REG_EXPORT_PATH=SharedDrive:\NewUserRegistry
mkdir !REG_EXPORT_PATH!

reg export "HKEY_USERS\"+!SID! !REG_EXPORT_PATH!\NTUser.dat

REM Step 4: Import the registry hive into the current user's registry
set CURRENT_USER_HIVE=HKEY_CURRENT_USER
set TEMP_REGISTRY_PATH=%TEMP%\TempRegistry

REM Create a temporary registry hive
reg load "!TEMP_REGISTRY_PATH!" !REG_EXPORT_PATH!\NTUser.dat

REM Merge the temporary registry hive with the current user's registry
reg merge "!TEMP_REGISTRY_PATH!\Software" "!CURRENT_USER_HIVE!\Software"

REM Unload the temporary registry hive
reg unload "!TEMP_REGISTRY_PATH!"

REM Cleanup: Remove the temporary files
rmdir /s /q !REG_EXPORT_PATH!
rmdir /s /q !TEMP_REGISTRY_PATH!

echo Batch file completed.
exit /b 0
