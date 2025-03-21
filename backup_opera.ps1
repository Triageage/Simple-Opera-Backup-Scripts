# Define source paths
$operaBookmarks = "C:\Users\krohi\AppData\Roaming\Opera Software\Opera Stable\Default\Bookmarks"
$operaExtensions = "C:\Users\krohi\AppData\Roaming\Opera Software\Opera Stable\Default\Extensions"
$operaCache = "C:\Users\krohi\AppData\Local\Opera Software\Opera Stable\Default"

# Define backup destination
$backupFolder = "C:\Opera_Backup"
$timestamp = Get-Date -Format "yyyy-MM-dd"
$backupPath = "$backupFolder\Backup_$timestamp"

# Function to log messages
function Log-Message($message) {
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "[$time] $message"
}

Log-Message "Starting Opera backup process..."

# Ensure backup directory exists
if (!(Test-Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null
    Log-Message "Created backup directory: $backupFolder"
} else {
    Log-Message "Backup directory exists: $backupFolder"
}

# Create timestamped backup folder
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

$oldBackups = Get-ChildItem -Path $backupFolder -Directory | Where-Object { $_.LastWriteTime -lt $oldDate }

if ($oldBackups.Count -gt 0) {
    foreach ($backup in $oldBackups) {
        Remove-Item $backup.FullName -Recurse -Force
        Log-Message "Deleted old backup: $($backup.FullName)"
    }
} else {
    Log-Message "No old backups found for deletion."
}

Log-Message "Backup cleanup completed."
