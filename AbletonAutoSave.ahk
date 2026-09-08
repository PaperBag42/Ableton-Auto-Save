#Requires AutoHotkey v2.0
#SingleInstance Force

#Include "config.ahk"
#Include "save.ahk"
#Include "menu.ahk"

Main()

Main() {
    A_IconTip := "Ableton Auto Save"
    Persistent() ; Keeps the script running in the background

    SetupTrayMenu()
    LoadConfigAndRun(AutoSaveEveryInterval)
}
