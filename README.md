# Opera Backup Script (AutoHotkey v2)

## Overview
This script automates the backup process for Opera browser bookmarks, extensions, and cache files. It finds the Opera installation, determines the profile path, and saves backups in a timestamped folder. It also automatically deletes backups older than 2 months.

## Available Scripts
There are two versions of the script available:
1. **Opera_Bookmarks_Backup_Working.ahk** – A stable version that has been tested and works reliably.
2. **Opera_Bookmarks_BackupTest.ahk** – The latest test version with potential improvements and fixes.

If you encounter any issues with `backup_opera_Test.ps1`, try using `Opera_Bookmarks_Backup_Working.ahk` instead.

## Requirements
- **Windows OS**
- **AutoHotkey v2.0+** (Download from [AutoHotkey Official Site](https://www.autohotkey.com/))
- Opera browser installed on your system

## Installation
1. Install **AutoHotkey v2.0+** if you haven’t already.
2. Download the script file (`Opera_Backup.ahk`).
3. Save the file in a preferred directory (e.g., `C:\Opera_Backup\`).

## Running the Script
### Method 1: Double-click Execution
- Double-click the `Opera_Backup.ahk` file to run the script.

### Method 2: Running via AutoHotkey
1. Open the terminal or command prompt.
2. Navigate to the script’s directory.
3. Run the command:
   ```sh
   autohotkey.exe Opera_Backup.ahk
   ```

## Script Functionality
- Detects the Opera installation path automatically.
- Asks the user for a backup save location (defaults to `C:\Opera_Backup`).
- Backs up:
  - **Bookmarks**
  - **Extensions**
  - **Cache (Default folder only)**
- Cleans up backups older than **2 months**.
- Provides user-friendly log messages via pop-ups.

## Restoring Backup
To restore a backup, replace the following files and folders with those from your backup:
- **Bookmarks:** Replace the `Bookmarks` file in `C:\Users\krohi\AppData\Roaming\Opera Software\Opera Stable\Default`
- **Extensions:** Replace the `Extensions` folder in `C:\Users\krohi\AppData\Roaming\Opera Software\Opera Stable\Default\Extensions`
- **Cache (Optional):** Replace the cache in `C:\Users\krohi\AppData\Local\Opera Software\Opera Stable\Default`

## Customization
- Change the default backup directory by modifying this line in the script:
  ```ahk
  backupFolder := "C:\Your_Custom_Backup_Path"
  ```
- Adjust the backup retention period (currently 2 months) by modifying:
  ```ahk
  minTimestamp := FormatTime(A_Now - 5184000, "yyyyMMdd")
  ```
  *(5184000 seconds = 60 days)*

## Troubleshooting
- **Opera not found error:** Ensure Opera is installed in `C:\Program Files\Opera\` or `C:\Program Files (x86)\Opera\`.
- **Invalid backup location error:** Ensure the entered path follows the format `D:\Backup_Folder`.
- **Script doesn’t run:** Ensure you installed AutoHotkey v2.

## License
This script is open-source and free to use and modify. Enjoy safe and easy Opera backups!

