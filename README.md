# Opera Backup Script (PowerShell)

## Overview
This PowerShell script automates the backup process for Opera browser bookmarks, extensions, and cache files. It detects the Opera installation, finds the profile path, and saves backups in a timestamped folder. It also automatically deletes backups older than 2 months.

## Requirements
- **Windows OS**
- **PowerShell (v5.1 or later)**
- Opera browser installed on your system

## Installation
1. Ensure PowerShell is installed (comes pre-installed on Windows 10/11).
2. Download the script files (`backup_opera_Test.ps1` and `backup_opera.ps1`).
3. Save the files in a preferred directory (e.g., `C:\Opera_Backup\`).

## Running the Script
### Available Scripts
There are two scripts available:
- **`backup_opera_Test.ps1`** (Latest version with improvements and fixes)
- **`backup_opera.ps1`** (Older stable version in case of issues with the latest one)

If you encounter any errors while running `backup_opera_Test.ps1`, try using `backup_opera.ps1` instead.

### Method 1: Running via PowerShell
1. Open PowerShell as Administrator.
2. Navigate to the script’s directory:
   ```powershell
   cd C:\Opera_Backup\
   ```
3. Run the script:
   ```powershell
   .\backup_opera_Test.ps1
   ```
   *(Or use `backup_opera.ps1` if needed: ` .\backup_opera.ps1` )*

### Method 2: Running with Execution Policy Bypass
If you encounter an execution policy restriction, use:
   ```powershell
   powershell -ExecutionPolicy Bypass -File C:\Opera_Backup\backup_opera_Test.ps1
   ```
   *(Or use `backup_opera.ps1` if needed: ` -File C:\Opera_Backup\backup_opera.ps1` )*

## Automating the Backup with Task Scheduler
To automate the backup process, create a scheduled task in Windows Task Scheduler:

### Step 1: Open Task Scheduler
1. Press `Win + R`, type `taskschd.msc`, and hit `Enter` to open Task Scheduler.
2. Click **Create Basic Task...** (on the right).
3. Name it **"Opera Backup"** and click **Next**.

### Step 2: Configure the Schedule
1. Select **Monthly**, then click **Next**.
2. Choose the **1st day of the month**, then click **Next**.
3. Select **Start a Program**, then click **Next**.

### Step 3: Set Up the Script Execution
1. In **Program/Script**, enter:
   ```
   powershell.exe
   ```
2. In **Add Arguments**, enter:
   ```
   -ExecutionPolicy Bypass -File "D:\Scripts\backup_opera.ps1"
   ```
   *(Change `D:\Scripts\backup_opera.ps1` to the actual path where you saved the script.)*
3. Click **Finish**.

## Script Functionality
- Detects the Opera installation path automatically.
- Prompts the user for a backup save location (defaults to `C:\Opera_Backup`).
- Backs up:
  - **Bookmarks**
  - **Extensions**
  - **Cache (Default folder only)**
- Deletes backups older than **2 months**.
- Provides log messages in the console.

## Restoring Backup
To restore a backup, replace the following files and folders with those from your backup:
- **Bookmarks:** Replace the `Bookmarks` file in `C:\Users\<YOUR USERNAME>\AppData\Roaming\Opera Software\Opera Stable\Default`
- **Extensions:** Replace the `Extensions` folder in `C:\Users\<YOUR USERNAME>\AppData\Roaming\Opera Software\Opera Stable\Default\Extensions`
- **Cache (Optional):** Replace the cache in `C:\Users\<YOUR USERNAME>\AppData\Local\Opera Software\Opera Stable\Default`

### Restoring Extensions (MAY NOT WORK FOR ALL EXTENSIONS)
After replacing the `Extensions` folder:
1. Restart Opera.
2. Open `opera://extensions/` in the Opera browser.
3. If extensions do not appear automatically, enable **Developer Mode** (toggle in the top-right corner).
4. Click **Load Unpacked** and select the extension folder inside `Extensions`.
5. Repeat for each extension if necessary.

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
