#Requires AutoHotkey v2.0
#SingleInstance Force

backupPath := "C:\Opera_Backup"
bookmarkFile := "C:\Users\krohi\AppData\Roaming\Opera Software\Opera Stable\Default\Bookmarks"
backupFile := backupPath "\Bookmarks_Backup_" A_Now ".json"

; Ensure the backup directory exists
if !FileExist(backupPath)
    DirCreate(backupPath)

; Check if the bookmarks file exists
if !FileExist(bookmarkFile) {
    MsgBox("Backup Failed`nFailed to find exported bookmarks file!", "Error", "OK Iconx")
    ExitApp()
}

; Copy the bookmark file to the backup location
FileCopy(bookmarkFile, backupFile, true)

; Notify the user
MsgBox("Backup Successful!`nSaved to: " backupFile, "Success", "OK Iconi")
ExitApp()
