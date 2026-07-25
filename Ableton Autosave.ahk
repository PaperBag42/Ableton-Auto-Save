#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent() ; Keeps the script running in the background

; Set Title Match Mode to 2 (Matches if the string occurs anywhere in the title)
SetTitleMatchMode(2)

; 1. Define file path and default values
ConfigFile := "ableton_auto_save.ini"
DefaultSettings := Map(
    "SaveEveryMinutes", 20,
    "IdleSeconds", 10,
)

; 2. Check if configuration file exists
if !FileExist(ConfigFile) {
    ShowSetupWindow()
} else {
    LoadSettingsAndRun()
}

; --- FUNCTIONS ---

ShowSetupWindow() {
    global ConfigFile, DefaultSettings

    ; Create GUI window
    SetupWindow := Gui("+AlwaysOnTop", "Ableton Auto Save First-Time Setup")
    SetupWindow.SetFont("s9", "Segoe UI")
    SetupWindow.OnEvent("Close", (*) => ExitApp())

    ; Add Input Fields using defaults
    SetupWindow.AddText("xm", "Every ")
    SaveIntervalInput := SetupWindow.Add("Edit", "vSaveEveryMinutes x+ yp-3 Number Center", DefaultSettings[
        "SaveEveryMinutes"])
    SetupWindow.AddText("x+5 yp+3", "minutes")

    SetupWindow.AddText("xm", "Wait for me to do nothing for ")
    IdleSecondsInput := SetupWindow.Add("Edit", "vIdleSeconds x+ yp-3 Number Center", DefaultSettings["IdleSeconds"])
    SetupWindow.AddText("x+5 yp+3", "seconds")

    SetupWindow.AddText("xm", "Then ")
    SaveMethodInput := SetupWindow.Add("DropDownList", "vSaveMethod x+ yp-3 Choose1 Center", ["Save",
        "Collect All and Save"])

    ; AutostartCheck := MyGui.Add("Checkbox", "vAutostart xm", "Start with Windows")
    ; AutostartCheck.Value := Integer(DefaultSettings["Autostart"])

    ; Add Save Button
    SaveButton := SetupWindow.Add("Button", "xm y+15 default", "Okay")
    SaveButton.OnEvent("Click", SaveSettings)
    CancelButton := SetupWindow.Add("Button", "x+10 yp", "Cancel")
    CancelButton.OnEvent("Click", (*) => ExitApp())

    SetupWindow.Show()

    ; Nested function to handle saving when button is clicked
    SaveSettings(*) {
        ; Write selections to the INI file
        IniWrite(SaveIntervalInput.Value, ConfigFile, "Options", "SaveEveryMinutes")
        IniWrite(IdleSecondsInput.Value, ConfigFile, "Options", "IdleSeconds")
        IniWrite(SaveMethodInput.Value, ConfigFile, "Options", "SaveMethod")

        SetupWindow.Destroy()
        LoadSettingsAndRun()
    }
}

LoadSettingsAndRun() {
    global ConfigFile

    ; Read the saved values from the INI file
    SaveEveryMinutes := IniRead(ConfigFile, "Options", "SaveEveryMinutes")

    SetTimer(CollectAndSaveAbleton, SaveEveryMinutes * 60 * 1000)
}

CollectAndSaveAbleton() {
    IdleSeconds := IniRead(ConfigFile, "Options", "IdleSeconds")

    ; Wait until the user has been completely idle for 10 seconds (10,000 ms)
    ; This loop pauses the script's save sequence if you are actively working
    while (A_TimeIdle < IdleSeconds * 1000) {
        Sleep(1000) ; Check your activity status again every 1 second
    }

    ; Check if Ableton Live is the active window
    if !WinActive("Ableton Live") {
        return
    }

    ; Displays a non-intrusive message near your mouse cursor
    ToolTip("Auto-Saving Project...")
    SetTimer(() => ToolTip(), -2000)

    ; 1. Open the File Menu (Alt + F)
    Send("!f")
    Sleep(200) ; Wait for menu to drop down

    ; 2. Press 'C' to select "Collect All and Save"
    Send("c")
    Sleep(200) ; Wait for the file selection dialog box to pop up

    ; 3. Press Enter to confirm the file collection options
    Send("{Enter}")

    ; Sleep(600) ; Wait for potential overwrite confirmations
    ; ; 4. Press Enter again to bypass any "Overwrite?" alerts
    ; Send("{Enter}")
}
