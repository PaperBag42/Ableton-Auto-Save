#Requires AutoHotkey v2.0

AppDir := A_AppData . "\AbletonAutoSave"

if !DirExist(AppDir) {
    DirCreate(AppDir)
}

RemoveAppDir() {
    DirDelete(AppDir)
}
