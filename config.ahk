#Requires AutoHotkey v2.0

#Include "appdir.ahk"

ConfigVersion := 1
ConfigFile := AppDir . "\ableton_auto_save.ini"
DefaultSettings := Map(
    "SaveEveryMinutes", 20,
    "IdleSeconds", 10,
)

LoadConfigAndRun(Callback) {
    if IniRead(ConfigFile, "Options", "Version", 0) != ConfigVersion {
        ShowSetupWindow(Callback)
    } else {
        SaveEveryMinutes := IniRead(ConfigFile, "Options", "SaveEveryMinutes")
        IdleSeconds := IniRead(ConfigFile, "Options", "IdleSeconds")
        CollectAllAndSave := IniRead(ConfigFile, "Options", "CollectAllAndSave")

        Callback(SaveEveryMinutes, IdleSeconds, CollectAllAndSave)
    }
}

ShowSetupWindow(Callback) {
    global ConfigFile, DefaultSettings

    ; Create GUI window
    SetupWindow := Gui("+AlwaysOnTop", "Ableton Auto Save First-Time Setup")
    SetupWindow.SetFont("s9", "Segoe UI")
    SetupWindow.OnEvent("Close", (*) => ExitApp())

    ; Add Input Fields using defaults
    SetupWindow.AddText("xm", "Every ")
    SaveIntervalInput := SetupWindow.Add(
        "Edit", "vSaveEveryMinutes x+ yp-3 Number Center", DefaultSettings["SaveEveryMinutes"])
    SetupWindow.AddText("x+5 yp+3", "minutes")

    SetupWindow.AddText("xm", "Wait for me to do nothing for ")
    IdleSecondsInput := SetupWindow.Add("Edit", "vIdleSeconds x+ yp-3 Number Center", DefaultSettings["IdleSeconds"])
    SetupWindow.AddText("x+5 yp+3", "seconds")

    SetupWindow.AddText("xm", "Then ")
    SaveMethodInput := SetupWindow.Add(
        "DropDownList", "vSaveMethod x+ yp-3 Choose1 Center", ["Save", "Collect All and Save"])

    CollectAllNote := SetupWindow.AddText("xm Disabled",
        "Note: Collect All and Save will prompt you to stop audio before saving.")

    ; Add Save Button
    SaveButton := SetupWindow.Add("Button", "xm y+15 default", "Okay")
    SaveButton.OnEvent("Click", SaveSettings)
    CancelButton := SetupWindow.Add("Button", "x+10 yp", "Cancel")
    CancelButton.OnEvent("Click", (*) => ExitApp())

    SetupWindow.Show()

    ; Nested function to handle saving when button is clicked
    SaveSettings(*) {
        SaveEveryMinutes := SaveIntervalInput.Value
        IdleSeconds := IdleSecondsInput.Value
        CollectAllAndSave := SaveMethodInput.Value == 2

        ; Write selections to the INI file
        IniWrite(ConfigVersion, ConfigFile, "Options", "Version")
        IniWrite(SaveEveryMinutes, ConfigFile, "Options", "SaveEveryMinutes")
        IniWrite(IdleSeconds, ConfigFile, "Options", "IdleSeconds")
        IniWrite(CollectAllAndSave, ConfigFile, "Options", "CollectAllAndSave")

        SetupWindow.Destroy()
        Callback(SaveEveryMinutes, IdleSeconds, CollectAllAndSave)
    }
}
