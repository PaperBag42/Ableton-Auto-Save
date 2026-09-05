#Requires AutoHotkey v2.0

#Include "appdir.ahk"

IsRunningFromStartup() {
    return A_WorkingDir == AppDir
}

AddToStartup() {
    AppDirExecutable := AppDir . "\AbletonAutoSave.exe"
    StartupLink := A_Startup . "\AbletonAutoSave.lnk"

    FileCopy(A_ScriptFullPath, AppDirExecutable, true)
    FileCreateShortcut(AppDirExecutable, StartupLink)
}
