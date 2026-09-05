#Requires AutoHotkey v2.0
#SingleInstance Force

#Include "config.ahk"
#Include "save.ahk"
#Include "startup.ahk"

Persistent() ; Keeps the script running in the background

Main(SaveEveryMinutes, IdleSeconds, CollectAll) {
    AddToStartup()
    AutoSaveEveryInterval(SaveEveryMinutes, IdleSeconds, CollectAll)
}

LoadConfigAndRun(Main)