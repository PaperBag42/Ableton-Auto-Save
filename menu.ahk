#Requires AutoHotkey v2.0

#Include "config.ahk"
#Include "save.ahk"
#Include "startup.ahk"

SetupTrayMenu() {
    A_TrayMenu.Delete()

    A_TrayMenu.Add("Configure", (*) => Configure())
    A_TrayMenu.Add("Exit", (*) => ExitApp())
    A_TrayMenu.Add("Uninstall", (*) => Uninstall())
}

Configure() {
    ReconfigureAndRun(AutoSaveEveryInterval)
}

Uninstall() {
    UninstallConfirmed := MsgBox("Are you sure you want to uninstall?", "Ableton Auto Save Uninstall", "Icon! YesNo")
    if UninstallConfirmed != "Yes" {
        return
    }

    RemoveFromStartup()
    RemoveConfigFile()
    RemoveAppDir()

    MsgBox("Uninstalled successfully.", "Ableton Auto Save Uninstall")
    ExitApp()
}
