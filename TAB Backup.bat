@echo off
setlocal

:: Set default source and destination folders
set "sourceFolder=They Are Billions"
set "destinationFolder=They Are Billions Save Backups"

:: Check if destination folder exists, create it if it doesn't
if not exist "%destinationFolder%" (
  mkdir "%destinationFolder%"
)

:menu
cls
echo 1. Run script
echo 2. Pick a backup
echo 3. Exit

set /p choice=Enter choice number:

if "%choice%"=="1" (
  goto run
) else if "%choice%"=="2" (
  goto pick
) else if "%choice%"=="3" (
  exit
) else (
  echo Invalid choice! Please try again.
  pause
  goto menu
)

:run
cls
echo Script is running. Press any key to stop and return to menu.

:loop
:: Get current timestamp
set "timestamp=%date:/=-%_%time::=.%"
set "timestamp=%timestamp: =0%"

:: Copy source folder to destination folder with timestamp
xcopy /E /I /Y "%sourceFolder%" "%destinationFolder%\%timestamp%"

:: Display countdown to next save
set /A "countdown=300"
echo Next save in %countdown% seconds...

:wait
timeout /T 1 /NOBREAK > NUL
set /A "countdown-=1"
if %countdown% GTR 0 goto wait

:: Check if user wants to stop script
if not exist "%destinationFolder%\stop.txt" goto loop

:: User wants to stop script, delete stop file and return to menu
del "%destinationFolder%\stop.txt"
goto menu

:pick
cls
echo Available backups:
echo.

:: List all folders in destination folder
for /D %%f in ("%destinationFolder%\*") do echo %%~nxf

echo.
set /p backupChoice=Enter backup name to restore:

:: Check if selected backup folder exists
if not exist "%destinationFolder%\%backupChoice%" (
  echo Invalid backup choice! Please try again.
  pause
  goto pick
)

:: Delete source folder and copy selected backup folder to source folder
rmdir /S /Q "%sourceFolder%"
xcopy /E /I /Y "%destinationFolder%\%backupChoice%" "%sourceFolder%"

echo Backup successfully restored!
pause
goto menu