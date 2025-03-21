# Function to log messages
function Log-Message($message) {
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "[$time] $message"
}

Log-Message "Starting Opera backup process..."

# Search for opera.exe in common locations
$operaPossiblePaths = @(
    "C:\Program Files\Opera\opera.exe",
    "C:\Program Files (x86)\Opera\opera.exe",
    "$env:LOCALAPPDATA\Programs\Opera\opera.exe"
)

$operaExe = $operaPossiblePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

if ($operaExe) {
    $operaInstallPath = Split-Path -Parent $operaExe
    Log-Message "Opera found at: $operaInstallPath"
} else {
    Log-Message "Opera.exe not found! Please ensure Opera is installed."
    exit
}

# Define source paths based on standard profile locations
$operaProfilePath = "$env:APPDATA\Opera Software\Opera Stable\Default"
$operaCachePath = "$env:LOCALAPPDATA\Opera Software\Opera Stable\Default"

$operaBookmarks = "$operaProfilePath\Bookmarks"
$operaExtensions = "$operaProfilePath\Extensions"
$operaCache = $operaCachePath

# Function to validate user input for the backup path
function Get-ValidBackupPath {
    do {
        $backupFolder = Read-Host "Enter the backup save location (Example: D:\Opera_Backup). Press Enter for default (C:\Opera_Backup)"
        $backupFolder = $backupFolder.Trim('"').Trim()  # Remove quotes and spaces

        if ([string]::IsNullOrWhiteSpace($backupFolder)) {
            $backupFolder = "C:\Opera_Backup"
        }

        # Validate input: Must be a valid drive path format
        if ($backupFolder -match "^[A-Za-z]:\\[^:*?<>|]+$" -and (Test-Path -Path (Split-Path -Path $backupFolder -Parent) -ErrorAction SilentlyContinue)) {
            return $backupFolder
        } else {
            Write-Host "⚠ Invalid path format! Please enter a valid path (Example: D:\Opera_Backup)" -ForegroundColor Red
        }
    } while ($true)
}

# Get a valid backup location from the user
$backupFolder = Get-ValidBackupPath
Log-Message "Backup will be saved to: $backupFolder"

# Create timestamped backup folder
$timestamp = Get-Date -Format "yyyy-MM-dd"
$backupPath = "$backupFolder\Backup_$timestamp"

# Ensure backup directory exists
if (!(Test-Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null
    Log-Message "Created backup directory: $backupFolder"
} else {
    Log-Message "Backup directory exists: $backupFolder"
}

if (!(Test-Path $backupPath)) {
    New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
    Log-Message "Created new backup folder: $backupPath"
} else {
    Log-Message "Backup folder already exists: $backupPath"
}

# Copy bookmarks file
if (Test-Path $operaBookmarks) {
    Copy-Item -Path $operaBookmarks -Destination "$backupPath\Bookmarks" -Force
    Log-Message "Successfully backed up Bookmarks."
} else {
    Log-Message "Bookmarks file not found! Skipping..."
}

# Copy extensions folder
if (Test-Path $operaExtensions) {
    Copy-Item -Path $operaExtensions -Destination "$backupPath\Extensions" -Recurse -Force
    Log-Message "Successfully backed up Extensions."
} else {
    Log-Message "Extensions folder not found! Skipping..."
}

# Copy cache folder
if (Test-Path $operaCache) {
    Copy-Item -Path $operaCache -Destination "$backupPath\Cache" -Recurse -Force
    Log-Message "Successfully backed up Cache."
} else {
    Log-Message "Cache folder not found! Skipping..."
}

Log-Message "Backup process completed successfully!"

# Delete backups older than 2 months
$oldDate = (Get-Date).AddMonths(-2)
Log-Message "Checking for backups older than 2 months..."

$oldBackups = Get-ChildItem -Path $backupFolder | Where-Object { $_.PSIsContainer -and $_.LastWriteTime -lt $oldDate }

if ($oldBackups.Count -gt 0) {
    foreach ($backup in $oldBackups) {
        Remove-Item $backup.FullName -Recurse -Force
        Log-Message "Deleted old backup: $($backup.FullName)"
    }
} else {
    Log-Message "No old backups found for deletion."
}

Log-Message "Backup cleanup completed."
