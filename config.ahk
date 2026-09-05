#Requires AutoHotkey v2.0

#Include "appdir.ahk"

ConfigVersion := 1
ConfigFile := AppDir . "\ableton_auto_save.ini"
DefaultConfig := Map(
    "SaveEveryMinutes", 20,
    "IdleSeconds", 10,
    "CollectAllAndSave", 0,
)

LoadConfigAndRun(Callback) {
    if IniRead(ConfigFile, "Options", "Version", 0) != ConfigVersion {
        ShowSetupWindow(Callback, ExitApp, DefaultConfig)
    } else {
        Config := ReadConfigFile()
        Callback(Config["SaveEveryMinutes"], Config["IdleSeconds"], Config["CollectAllAndSave"])
    }
}

ReconfigureAndRun(Callback) {
    ShowSetupWindow(Callback, () => {}, ReadConfigFile())
}

ShowSetupWindow(OnSuccess, OnCancel, CurrentConfig) {
    ; Create GUI window
    SetupWindow := Gui("+AlwaysOnTop", "Ableton Auto Save Setup")
    SetupWindow.SetFont("s9", "Segoe UI")
    SetupWindow.OnEvent("Close", Cancel)

    ; Add Input Fields using defaults
    SetupWindow.AddText("xm", "Every ")
    SaveIntervalInput := SetupWindow.Add(
        "Edit", "vSaveEveryMinutes x+ yp-3 Number Center", CurrentConfig["SaveEveryMinutes"])
    SetupWindow.AddText("x+5 yp+3", "minutes")

    SetupWindow.AddText("xm", "Wait for me to do nothing for ")
    IdleSecondsInput := SetupWindow.Add("Edit", "vIdleSeconds x+ yp-3 Number Center", CurrentConfig["IdleSeconds"])
    SetupWindow.AddText("x+5 yp+3", "seconds")

    SetupWindow.AddText("xm", "Then ")
    SaveMethodInput := SetupWindow.Add(
        "DropDownList", "vSaveMethod x+ yp-3 Choose1 Center", ["Save", "Collect All and Save"])
    SaveMethodInput.Value := CurrentConfig["CollectAllAndSave"] == 1 ? 2 : 1

    CollectAllNote := SetupWindow.AddText("xm",
        "* Note: Collect All and Save will prompt you to stop audio before saving.")
    ShowCollectAllNote()
    SaveMethodInput.OnEvent("Change", ShowCollectAllNote)

    ; Add Save Button
    SaveButton := SetupWindow.Add("Button", "xm y+15 default", "Okay")
    SaveButton.OnEvent("Click", SaveSettings)
    CancelButton := SetupWindow.Add("Button", "x+10 yp", "Cancel")
    CancelButton.OnEvent("Click", Cancel)

    SetupWindow.Show()

    ShowCollectAllNote(*) {
        CollectAllNote.Visible := SaveMethodInput.Value == 2
    }

    SaveSettings(*) {
        SaveEveryMinutes := SaveIntervalInput.Value
        IdleSeconds := IdleSecondsInput.Value
        CollectAllAndSave := SaveMethodInput.Value == 2

        WriteConfigFile(Map(
            "SaveEveryMinutes", SaveEveryMinutes,
            "IdleSeconds", IdleSeconds,
            "CollectAllAndSave", CollectAllAndSave
        ))

        SetupWindow.Destroy()
        OnSuccess(SaveEveryMinutes, IdleSeconds, CollectAllAndSave)
    }

    Cancel(*) {
        OnCancel()
        SetupWindow.Destroy()
    }
}

ReadConfigFile() {
    return Map(
        "SaveEveryMinutes", IniRead(ConfigFile, "Options", "SaveEveryMinutes"),
        "IdleSeconds", IniRead(ConfigFile, "Options", "IdleSeconds"),
        "CollectAllAndSave", IniRead(ConfigFile, "Options", "CollectAllAndSave"),
    )
}

WriteConfigFile(Config) {
    IniWrite(ConfigVersion, ConfigFile, "Options", "Version")
    for Key, Value in Config {
        IniWrite(Value, ConfigFile, "Options", Key)
    }
}

RemoveConfigFile() {
    FileDelete(ConfigFile)
}
