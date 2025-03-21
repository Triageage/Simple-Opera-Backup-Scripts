# Opera Backup Script (PowerShell)

## Overview
This PowerShell script automates the backup process for Opera browser bookmarks, extensions, and cache files. It detects the Opera installation, finds the profile path, and saves backups in a timestamped folder. It also automatically deletes backups older than 2 months.

## Requirements
- **Windows OS**
- **PowerShell (v5.1 or later)**
- Opera browser installed on your system

## Installation
1. Ensure PowerShell is installed (comes pre-installed on Windows 10/11).
2. Download the script file (`Opera_Backup.ps1`).
3. Save the file in a preferred directory (e.g., `C:\Opera_Backup\`).

## Running the Script
### Method 1: Running via PowerShell
1. Open PowerShell as Administrator.
2. Navigate to the script’s directory:
   ```powershell
   cd C:\Opera_Backup\
   ```
3. Run the script:
   ```powershell
   .\Opera_Backup.ps1
   ```

### Method 2: Running with Execution Policy Bypass
If you encounter an execution policy restriction, use:
   ```powershell
   powershell -ExecutionPolicy Bypass -File C:\Opera_Backup\Opera_Backup.ps1
   ```

## Script Functionality
- Detects the Opera installation path automatically.
- Prompts the user for a backup save location (defaults to `C:\Opera_Backup`).
- Backs up:
  - **Bookmarks**
  - **Extensions**
  - **Cache (Default folder only)**
- Deletes backups older than **2 months**.
- Provides log messages in the console.

## Customization
- Change the default backup directory by modifying this line:
  ```powershell
  $backupFolder = "C:\Your_Custom_Backup_Path"
  ```
- Adjust the backup retention period (currently 2 months) by modifying:
  ```powershell
  $oldDate = (Get-Date).AddMonths(-2)
  ```

## Troubleshooting
- **Opera not found error:** Ensure Opera is installed in `C:\Program Files\Opera\` or `C:\Program Files (x86)\Opera\`.
- **Invalid backup location error:** Ensure the entered path follows the format `D:\Backup_Folder`.
- **Script doesn’t run:** Ensure PowerShell execution policy allows scripts. Run:
  ```powershell
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

## License
This script is open-source and free to use and modify. Enjoy safe and easy Opera backups!

