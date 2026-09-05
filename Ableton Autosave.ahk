#Requires AutoHotkey v2.0
#SingleInstance Force

#Include "config.ahk"
#Include "save.ahk"
#Include "startup.ahk"

Persistent() ; Keeps the script running in the background

SetupTrayMenu()
LoadConfigAndRun(Main)

Main(SaveEveryMinutes, IdleSeconds, CollectAll) {
    ; add to startup only after the user pressed OK
    if !IsRunningFromStartup() {
        AddToStartup()
    }

    AutoSaveEveryInterval(SaveEveryMinutes, IdleSeconds, CollectAll)
}

SetupTrayMenu() {
    A_TrayMenu.Delete()

    A_TrayMenu.Add("Configure", (*) => Configure())
    A_TrayMenu.Add("Exit", (*) => ExitApp())
    A_TrayMenu.Add("Uninstall", (*) => Uninstall())
}

Configure() {
    ShowSetupWindow(AutoSaveEveryInterval)
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
