#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"

log(msg) {
    time := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
    MsgBox("[" time "] " msg, "Opera Backup", "T1")
}

log("🚀 Starting Opera backup process...")

; **Find Opera Installation Path**
operaExe := ""

Loop Files, "C:\Program Files\Opera\opera.exe", "R" {
    operaExe := A_LoopFileFullPath
    Break
}
Loop Files, "C:\Program Files (x86)\Opera\opera.exe", "R" {
    operaExe := A_LoopFileFullPath
    Break
}

if (operaExe = "") {
    log("❌ Opera.exe not found! Please ensure Opera is installed.")
    ExitApp
}

; **Fix: Only use InStr() if operaExe is valid**
if (StrLen(operaExe) > 0) {
    pos := InStr(operaExe, "\",, -1)  ; Removed the unnecessary 0 parameter
    if (pos > 0) {
        operaInstallPath := SubStr(operaExe, 1, pos - 1)
        log("✅ Opera found at: " operaInstallPath)
    } else {
        log("⚠️ Unable to determine Opera install path. Continuing backup anyway.")
        operaInstallPath := "C:\Unknown_Opera_Path"
    }
} else {
    log("❌ Error finding Opera install path!")
    ExitApp
}

; **Ask user for backup location**
backupFolder := ""
Loop {
    input := InputBox("
    (
    Enter the backup save location (Example: D:\Opera_Backup).
    Press OK for default: C:\Opera_Backup
    )", "Backup Location")

    backupFolder := input.Value  ; Extract value from object

    if backupFolder = "" {
        backupFolder := "C:\Opera_Backup"
    }

    if RegExMatch(backupFolder, "^[A-Z]:\\") {
        Break
    }

    MsgBox("⚠️ Invalid path! Please enter in the format 'D:\\Folder'.", "Error", "T1")
}

log("📂 Backup will be saved to: " backupFolder)

; **Define source paths**
operaProfile := EnvGet("APPDATA") "\Opera Software\Opera Stable\Default"
possibleCachePaths := [
    EnvGet("LOCALAPPDATA") "\Opera Software\Opera Stable",
    EnvGet("APPDATA") "\Opera Software\Opera Stable"
]

cacheFolder := ""
for path in possibleCachePaths {
    if DirExist(path "\Default") {
        cacheFolder := path "\Default"
        Break
    }
}

; **Create timestamped backup folder**
timestamp := FormatTime(A_Now, "yyyyMMdd")
backupPath := backupFolder "\Backup_" timestamp

if !DirExist(backupFolder) {
    DirCreate(backupFolder)
    log("📁 Created backup directory: " backupFolder)
}

if !DirExist(backupPath) {
    DirCreate(backupPath)
    log("📁 Created new backup folder: " backupPath)
}

; **Backup Bookmarks**
if FileExist(operaProfile "\Bookmarks") {
    FileCopy(operaProfile "\Bookmarks", backupPath "\Bookmarks", 1)
    log("✅ Successfully backed up Bookmarks.")
} else {
    log("⚠️ Bookmarks file not found! Skipping...")
}

; **Backup Extensions**
if DirExist(operaProfile "\Extensions") {
    DirCopy(operaProfile "\Extensions", backupPath "\Extensions", 1)
    log("✅ Successfully backed up Extensions.")
} else {
    log("⚠️ Extensions folder not found! Skipping...")
}

; **Backup only "Default" subfolder inside Cache**
if cacheFolder {
    if DirExist(cacheFolder) {
        DirCopy(cacheFolder, backupPath "\Cache\Default", 1)
        log("✅ Successfully backed up Cache (Default only).")
    } else {
        log("⚠️ 'Default' subfolder not found inside Cache! Skipping...")
    }
} else {
    log("⚠️ Cache folder not found! Skipping...")
}

log("✅ Backup process completed successfully!")

; **Delete backups older than 2 months**
log("🔍 Checking for backups older than 2 months...")
minTimestamp := FormatTime(A_Now - 5184000, "yyyyMMdd")

Loop Files backupFolder "\Backup_*", "D" {
    backupDate := SubStr(A_LoopFileName, 8)

    if (StrLen(backupDate) = 8 && backupDate < minTimestamp) {
        DirDelete(A_LoopFileFullPath, 1)
        log("🗑️ Deleted old backup: " A_LoopFileFullPath)
    }
}

log("🧹 Backup cleanup completed.")
ExitApp
