# CyberPatriot Competition Script for Ubuntu Linux

This script is designed to automate various configuration and security tasks for Ubuntu Linux machines participating in the CyberPatriot competition. It provides a convenient way to perform common setup steps, user management, system configuration, software updates, and more.

## Script Overview

The script is written in Bash and consists of several sections:

1. System Configuration
2. User Accounts and Passwords
3. User Permissions
4. Unnecessary Services
5. Network Configuration
6. Software Updates
7. Install Additional Apps
8. Cleanup and Final Steps

Each section can be individually enabled or disabled based on your specific requirements. You can customize the script by providing user input to determine which sections to run.

## How to Use

1. Make sure you have administrative privileges on the Ubuntu Linux machine.

2. Copy the `script.sh` file to the Ubuntu Linux machine.

3. Customize the script by modifying the options and files mentioned in the script itself:

   - Modify the `user_accounts.txt` file to specify the desired user accounts and passwords.
   - Modify the `user_permissions.txt` file to define the user permissions (admin or not admin).
   - Modify the `additional_apps.txt` file to specify the additional apps you want to install using Chocolatey.

4. Open a terminal on the Ubuntu Linux machine.

5. Navigate to the directory where the `script.sh` file is located.

6. Run the script by executing the following command:

   ```bash
   sudo bash script.sh
