#Requires AutoHotkey v2.0

AddToStartup() {
    StartupExecutable := A_Startup . "\AbletonAutoSave.exe"

    if !FileExist(StartupExecutable) {
        try {
            FileCopy(A_ScriptFullPath, StartupExecutable)
        } catch as err {
            MsgBox("Failed to create startup shortcut: " . err.Message, "Error", 16)
        }
    }
}
