#Requires AutoHotkey v2.0
#SingleInstance Force

#Include "config.ahk"
#Include "save.ahk"
#Include "startup.ahk"
#Include "menu.ahk"

Main()

Main() {
    A_IconTip := "Ableton Auto Save"
    Persistent() ; Keeps the script running in the background

    SetupTrayMenu()
    LoadConfigAndRun(OnConfigLoaded)
}

OnConfigLoaded(SaveEveryMinutes, IdleSeconds, CollectAll) {
    ; add to startup only after the user pressed OK
    if !IsRunningFromStartup() {
        AddToStartup()
    }

    AutoSaveEveryInterval(SaveEveryMinutes, IdleSeconds, CollectAll)
}
