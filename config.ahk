#Requires AutoHotkey v2.0

ConfigVersion := 1
ConfigFile := "ableton_auto_save.ini"
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
        SaveMethod := IniRead(ConfigFile, "Options", "SaveMethod")

        Callback(SaveEveryMinutes, IdleSeconds, SaveMethod)
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
        SaveMethod := SaveMethodInput.Value

        ; Write selections to the INI file
        IniWrite(ConfigVersion, ConfigFile, "Options", "Version")
        IniWrite(SaveIntervalInput.Value, ConfigFile, "Options", "SaveEveryMinutes")
        IniWrite(IdleSecondsInput.Value, ConfigFile, "Options", "IdleSeconds")
        IniWrite(SaveMethodInput.Value, ConfigFile, "Options", "SaveMethod")

        SetupWindow.Destroy()
        Callback(SaveEveryMinutes, IdleSeconds, SaveMethod)
    }
}
