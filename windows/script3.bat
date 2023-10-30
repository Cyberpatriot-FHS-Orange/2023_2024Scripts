@echo off
setlocal enabledelayedexpansion

:menu
echo Select an option:
echo 1. Disable Guest Account (through GPO)
echo 2. List and Modify User Accounts
echo 3. Set Complex Passwords for Non-Admin Users
echo 4. Turn On User Account Control
echo 5. Enable Updates for Other Microsoft Products
echo 6. Turn Off Autoplay (through Gpedit)
echo 7. Limit Local Use of Blank Passwords to Local Console (ENABLED)
echo 8. Do Not Require CTRL+ALT+DEL (DISABLED)
echo 9. Clear Virtual Memory Pagefile (ENABLED)
echo 10. Enable Smartscreen
echo 11. Disable Remote RDP Network Level Authentication (GPEDIT)
echo 12. Check Apps and Files ON (Smartscreen)
echo 13. Disable Routing and Remote Access
echo 14. Disable Net. Tcp Port Sharing
echo 15. Enable DHCP
echo 16. Start Firewall Service and Turn On Firewall
echo 17. Delete Non-Essential Media/Text Files
echo 18. Set Admin and Standard User Permissions
echo 19. Unnecessary Services
echo 20. Network Configuration
echo 21. Cleanup and Final Steps
echo 22. List and Terminate Processes
echo 23. Enable All Auditing
echo 24. Exit

set /p choice="Enter your choice: "

if "%choice%"=="1" (
    echo Disabling Guest Account (through GPO)...
    net user Guest /active:no
    :: Disable Guest Account via GPO here
)

if "%choice%"=="2" (
    echo Listing and Modifying User Accounts...

    :: List all user accounts
    for /f "tokens=*" %%u in ('net user ^| findstr /i /v "Administrator Guest"') do (
        set "user=%%u"
        echo Current status for !user!:
        
        :: Check if the user is an admin or local user
        net localgroup Administrators | findstr /i /c:"!user!" >nul
        if !errorlevel! equ 0 (
            echo - Admin
        ) else (
            echo - Local
        )

        set /p modify_user="Do you want to change the status (admin/local), delete the user, or do nothing (admin/local/delete/nothing)? "
        
        if /I "!modify_user!"=="admin" (
            net localgroup Administrators "!user!" /add
            echo User !user! changed to Admin.
        ) else if /I "!modify_user!"=="local" (
            net localgroup Administrators "!user!" /delete
            echo User !user! changed to Local.
        ) else if /I "!modify_user!"=="delete" (
            set /p confirm_delete="Are you sure you want to delete user !user!? (yes/no): "
            if /I "!confirm_delete!"=="yes" (
                net user !user! /delete
                echo User !user! deleted.
            ) else (
                echo User !user! was not deleted.
            )
        ) else (
            echo Nothing was done for user !user!.
        )
    )

    echo User accounts list and modification completed.
)

if "%choice%"=="3" (
    echo Setting Complex Passwords for Non-Admin Users...
    set /p complex_password="Enter the complex password: "
    for /f "tokens=*" %%i in ('net user ^| findstr /i /v "Administrator Guest"') do (
        set "user=%%i"
        net user !user! !complex_password!
    )
)

if "%choice%"=="4" (
    echo Turning On User Account Control...
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f
)

if "%choice%"=="5" (
    echo Enabling Updates for Other Microsoft Products...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d 4 /f
)

if "%choice%"=="6" (
    echo Turning Off Autoplay...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f
)

if "%choice%"=="7" (
    echo Enabling Local Use of Blank Passwords to Local Console...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f
)

if "%choice%"=="8" (
    echo Requiring CTRL+ALT+DEL...
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableCAD /t REG_DWORD /d 0 /f
)

if "%choice%"=="9" (
    echo Clearing Virtual Memory Pagefile...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 1 /f
)

if "%choice%"=="10" (
    echo Enabling Smartscreen...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 1 /f
)

if "%choice%"=="11" (
    echo Disabling Remote RDP Network Level Authentication...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "UserAuthentication" /t REG_DWORD /d 0 /f
)

if "%choice%"=="12" (
    echo Checking Apps and Files ON (Smartscreen)...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d 1 /f
)

if "%choice%"=="13" (
    echo Disabling Routing and Remote Access...
    net stop RemoteAccess
    sc config RemoteAccess start=disabled
)

if "%choice%"=="14" (
    echo Disabling Net. Tcp Port Sharing...
    sc config iphlpsvc start=disabled
)

if "%choice%"=="15" (
    echo Enabling DHCP...
    netsh int ipv4 set address "Local Area Connection" source=dhcp
)

if "%choice%"=="16" (
    echo Starting Firewall Service and Turning On Firewall...
    net start MpsSvc
    netsh advfirewall set allprofiles state on
)

if "%choice%"=="17" (
    set /p folder_path="Enter the folder path where you want to delete files: "
    
    :: Define a list of file extensions to be deleted (you can customize this list).
    set "extensions_to_delete=*.txt *.jpg *.png"

    :: Display a list of files to be deleted along with their file locations.
    echo Files to be deleted:
    for /r "%folder_path%" %%f in (%extensions_to_delete%) do (
        echo "%%f"
    )
    
    set /p confirm_delete="Are you sure you want to delete these files? (yes/no): "
    if "!confirm_delete!"=="yes" (
        :: Loop through the specified folder and its subfolders and delete the selected file extensions.
        for /r "%folder_path%" %%f in (%extensions_to_delete%) do (
            del "%%f" /q
            echo Deleted: "%%f"
        )
        echo Files deleted. Make sure to review the results.
    ) else (
        echo Deletion canceled.
    )
)

if "%choice%"=="18" (
    echo Setting Admin and Standard User Permissions...

    :: You can add code here to set permissions for user accounts.
    
    :: Call the password policy script
    call :passwdPol
)

if "%choice%"=="19" (
    echo Stopping unnecessary services...
    sc stop Telnet
    sc config Telnet start=disabled
    sc stop FTP
    sc config FTP start=disabled
    sc stop RemoteRegistry
    sc config RemoteRegistry start=disabled
    sc stop SNMP
    sc config SNMP start=disabled
)

if "%choice%"=="20" (
    echo Configuring network settings...
    :: You can add code here to configure network settings.
)

if "%choice%"=="21" (
    echo Cleanup and final steps...
    ipconfig /flushdns
    del /f /q "%TEMP%\*.*"
)

if "%choice%"=="22" (
    echo Listing and Terminating Processes...
    
    :: List all running processes
    for /f "tokens=*" %%a in ('tasklist') do (
        set "process=%%a"
        echo !process!
        
        set /p terminate="Terminate this process? (yes/no): "
        if /I "!terminate!"=="yes" (
            for /f "tokens=1" %%b in ("!process!") do (
                taskkill /F /IM %%b
            )
        )
    )

    echo Process list completed.
)

if "%choice%"=="23" (
    :: Enable all auditing
    echo Enabling all auditing...
    auditpol /set /category:"*:*" /success:enable /failure:enable
)

if "%choice%"=="24" (
    exit /b
)

goto menu

:passwdPol
rem Sets the password policy
rem Set complexity requirements
echo Setting password policies
net accounts /minpwlen:8
net accounts /maxpwage:60
net accounts /minpwage:10
net accounts /uniquepw:3

pause
goto :EOF
