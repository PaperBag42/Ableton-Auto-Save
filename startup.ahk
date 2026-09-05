#Requires AutoHotkey v2.0

#Include "appdir.ahk"

AppDirExecutable := AppDir . "\AbletonAutoSave.exe"
StartupLink := A_Startup . "\AbletonAutoSave.lnk"

IsRunningFromStartup() {
    return A_WorkingDir == AppDir
}

AddToStartup() {
    FileCopy(A_ScriptFullPath, AppDirExecutable, true)
    FileCreateShortcut(AppDirExecutable, StartupLink)
}

RemoveFromStartup() {
    FileDelete(StartupLink)
    FileDelete(AppDirExecutable)
}
