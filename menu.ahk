#Requires AutoHotkey v2.0

#Include "config.ahk"
#Include "save.ahk"

SetupTrayMenu() {
    A_TrayMenu.Delete()

    A_TrayMenu.Add("Configure", (*) => Configure())
    A_TrayMenu.Add("Exit", (*) => ExitApp())
}

Configure() {
    ReconfigureAndRun(AutoSaveEveryInterval)
}
