# CyberPatriot Competition Script for Windows Machines

This script is designed to automate various configuration and security tasks for Windows machines participating in the CyberPatriot competition. It provides a convenient way to perform common setup steps, user management, system configuration, software updates, and more.

## Script Overview

The script is written in batch script (.bat) format and consists of several sections:

1. System Configuration
2. User Accounts and Passwords
3. Set Admin and Standard User Permissions
4. Unnecessary Services
5. Network Configuration
6. Software Updates - Firefox
7. Install Additional Apps from File
8. Software Updates
9. Cleanup and Final Steps

Each section can be individually enabled or disabled based on your specific requirements. You can customize the script by providing user input to determine which sections to run.

## How to Use

1. Make sure you have administrative privileges on the Windows machine.

2. Copy the script to the Windows machine.

3. Customize the script by modifying the options and files mentioned in the script itself:

   - Modify the `user_accounts.txt` file to specify the desired user accounts and passwords.
   - Modify the `user_permissions.txt` file to define the user permissions (admin or not admin).
   - Update the `additional_apps.txt` file with the list of additional apps you want to install using Chocolatey.

4. Open a command prompt with administrative privileges.

5. Navigate to the directory where the script is located.

6. Run the script by executing the following command:


7. Follow the prompts in the command prompt to select which sections to run.

8. The script will execute the selected sections, performing the necessary configurations and tasks.

9. Review the script output for any errors or issues.

## Additional Notes

- It is recommended to run the script in a test environment or on non-production machines before using it in a live competition environment.

- Please ensure you have read and understood the script before running it to avoid unintended consequences or data loss.

- Make sure you have a backup of important files and data before running the script.

- The script assumes that Chocolatey is already installed on the machine. If Chocolatey is not installed, it will attempt to install it automatically.

- The script uses Chocolatey to install additional apps specified in the `additional_apps.txt` file. Make sure to update the file with the desired apps.

- The script includes a software update section that can be enabled to update the installed software using Chocolatey.

- The cleanup and final steps section includes commands to flush the DNS cache and clear temporary files.