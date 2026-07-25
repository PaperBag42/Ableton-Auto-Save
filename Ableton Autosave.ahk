#Requires AutoHotkey v2.0
#SingleInstance Force

#Include "config.ahk"
#Include "save.ahk"

Persistent() ; Keeps the script running in the background

LoadConfigAndRun(AutoSaveEveryInterval)