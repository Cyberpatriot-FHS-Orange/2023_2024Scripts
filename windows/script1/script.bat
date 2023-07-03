@echo off

REM ========================================================
REM CyberPatriot Competition Script for Windows Machines
REM ========================================================

REM ----------------------------------------
REM Check if Chocolatey is installed
REM ----------------------------------------
choco -v >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Chocolatey package manager...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    echo Chocolatey installed successfully.
)

REM ----------------------------------------
REM System Configuration
REM ----------------------------------------
set /p run_system_config=Run system configuration? (Y/N): 
if /I "%run_system_config%"=="Y" (
    echo Updating Windows Defender...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate

    echo Disabling AutoPlay...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 0xFF /f
    reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 0xFF /f

    echo Configuring Windows Firewall...
    netsh advfirewall set allprofiles state off

    echo Disabling Remote Desktop...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
)

REM ----------------------------------------
REM User Accounts and Passwords
REM ----------------------------------------
set /p run_user_accounts=Run user accounts and passwords setup? (Y/N): 
if /I "%run_user_accounts%"=="Y" (
    echo Setting up user accounts...

    REM Read user accounts and permissions from files
    setlocal enabledelayedexpansion

    REM Create a list of existing users
    set "existing_users="
    for /F "tokens=1 delims=," %%a in ('net user ^| findstr /R "^[a-zA-Z]"') do (
        set "existing_users=!existing_users!%%a,"
    )

    REM Read user accounts and passwords from file
    for /F "tokens=1,2 delims=," %%a in (user_accounts.txt) do (
        REM Check if the user already exists
        echo Checking user: %%a
        echo !existing_users! | findstr /C:"%%a," >nul
        if %errorlevel% equ 0 (
            echo User %%a already exists. Skipping account creation.
        ) else (
            echo Creating user: %%a
            net user %%a %%b /add
        )

        REM Remove the user from the existing users list
        set "existing_users=!existing_users:%%a,=!"
    )

    REM Delete any remaining users not in the list
    for %%u in (!existing_users!) do (
        echo Deleting user: %%u
        net user %%u /delete
    )

    endlocal
)

REM ----------------------------------------
REM Set Admin and Standard User Permissions
REM ----------------------------------------
set /p run_user_permissions=Run user permissions setup? (Y/N): 
if /I "%run_user_permissions%"=="Y" (
    echo Setting user permissions...

    REM Read user accounts and permissions from files
    setlocal enabledelayedexpansion

    REM Create a list of existing users
    set "existing_users="
    for /F "tokens=1 delims=," %%a in ('net user ^| findstr /R "^[a-zA-Z]"') do (
        set "existing_users=!existing_users!%%a,"
    )

    REM Read user accounts and permissions from files
    for /F "tokens=1,2 delims=," %%a in (user_permissions.txt) do (
        REM Check if the user exists
        echo Checking user: %%a
        echo !existing_users! | findstr /C:"%%a," >nul
        if %errorlevel% equ 0 (
            echo Setting permissions for user: %%a
            if /I "%%b"=="admin" (
                net localgroup Administrators %%a /add
            ) else (
                net localgroup Administrators %%a /delete
            )
        ) else (
            echo User %%a not found. Skipping permissions setup.
        )

        REM Remove the user from the existing users list
        set "existing_users=!existing_users:%%a,=!"
    )

    REM Delete any remaining users not in the list
    for %%u in (!existing_users!) do (
        echo Deleting user: %%u
        net user %%u /delete
    )

    endlocal
)

REM ----------------------------------------
REM Unnecessary Services
REM ----------------------------------------
set /p run_unnecessary_services=Run unnecessary services setup? (Y/N): 
if /I "%run_unnecessary_services%"=="Y" (
    echo Stopping unnecessary services...
    sc stop Telnet
    sc config Telnet start= disabled
    sc stop FTP
    sc config FTP start= disabled
    sc stop RemoteRegistry
    sc config RemoteRegistry start= disabled
    sc stop SNMP
    sc config SNMP start= disabled
)

REM ----------------------------------------
REM Network Configuration
REM ----------------------------------------
set /p run_network_configuration=Run network configuration setup? (Y/N): 
if /I "%run_network_configuration%"=="Y" (
    echo Configuring network settings...

    REM Disable IPv6
    netsh interface ipv6 uninstall

    REM Disable NetBIOS over TCP/IP
    wmic nicconfig where TcpipNetbiosOptions=0 call SetTcpipNetbios 2

    REM Enable Windows Firewall
    netsh advfirewall set allprofiles state on

    REM Enable Windows Defender Firewall
    netsh advfirewall set allprofiles state on
)

REM ----------------------------------------
REM Software Updates - Firefox
REM ----------------------------------------
set /p run_firefox_update=Run Firefox update? (Y/N): 
if /I "%run_firefox_update%"=="Y" (
    REM ----------------------------------------
    REM Stop Firefox Processes
    REM ----------------------------------------
    echo Stopping Firefox processes...
    taskkill /IM firefox.exe /F

    REM ----------------------------------------
    REM Download Latest Firefox Installer
    REM ----------------------------------------
    echo Downloading the latest Firefox installer...
    powershell -command "& {Invoke-WebRequest -Uri 'https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US' -OutFile 'FirefoxSetup.exe'}"

    REM ----------------------------------------
    REM Uninstall Existing Firefox
    REM ----------------------------------------
    echo Uninstalling existing Firefox...
    start /wait "" "C:\Program Files\Mozilla Firefox\uninstall\helper.exe" /s

    REM ----------------------------------------
    REM Install Latest Firefox
    REM ----------------------------------------
    echo Installing the latest Firefox...
    start /wait "" "FirefoxSetup.exe" -ms

    REM ----------------------------------------
    REM Cleanup
    REM ----------------------------------------
    echo Cleaning up temporary files...
    del /f /q "FirefoxSetup.exe"
)

REM ----------------------------------------
REM Install Additional Apps from File
REM ----------------------------------------
set /p run_additional_apps=Run installation of additional apps from file? (Y/N): 
if /I "%run_additional_apps%"=="Y" (
    echo Installing additional apps...

    REM Install Chocolatey if not already installed
    choco -v >nul 2>&1
    if %errorlevel% neq 0 (
        echo Installing Chocolatey package manager...
        powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
        echo Chocolatey installed successfully.
    )

    REM Read additional apps from file
    for /F "delims=" %%a in (additional_apps.txt) do (
        echo Installing app: %%a
        choco install %%a -y
    )
)

REM ----------------------------------------
REM Software Updates
REM ----------------------------------------
set /p run_software_updates=Run software updates? (Y/N): 
if /I "%run_software_updates%"=="Y" (
    echo Checking for software updates...
    choco upgrade all -y
)

REM ----------------------------------------
REM Cleanup and Final Steps
REM ----------------------------------------
set /p run_cleanup=Run cleanup and final steps? (Y/N): 
if /I "%run_cleanup%"=="Y" (
    echo Cleanup and final steps...

    REM Flush DNS Cache
    ipconfig /flushdns

    REM Clear Temporary Files
    del /f /q "%TEMP%\*.*"
)

echo Script execution completed.
pause
