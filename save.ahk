#Requires AutoHotkey v2.0

global CurrentTimer := unset

; Set Title Match Mode to 2 (Matches if the string occurs anywhere in the title)
SetTitleMatchMode(2)

AutoSaveEveryInterval(SaveEveryMinutes, IdleSeconds, CollectAll) {
    if (IsSet(CurrentTimer)) {
        SetTimer(CurrentTimer, 0)
    }

    CurrentTimer := () => AbletonAutoSave(IdleSeconds, CollectAll)
    SetTimer(CurrentTimer, SaveEveryMinutes * 60 * 1000)
}

AbletonAutoSave(IdleSeconds, CollectAll) {
    ; Check if Ableton Live is open
    if !WinExist("Ableton Live") {
        return
    }

    ; Wait until the user has been completely idle for IdleSeconds
    ; This loop pauses the script's save sequence if you are actively working
    while (WinActive("Ableton Live") and A_TimeIdle < IdleSeconds * 1000) {
        Sleep(1000)
    }

    ; Displays a non-intrusive message near your mouse cursor
    ToolTip("Auto-Saving Project...")
    SetTimer(() => ToolTip(), -2000)

    if (!CollectAll) {
        Save()
    } else {
        CollectAllAndSave()
    }
}

Save() {
    ControlSend("^s", , "Ableton Live")
}

CollectAllAndSave() {
    ; 1. Open the File Menu (Alt + F)
    ControlSend("!f", , "Ableton Live")
    Sleep(200) ; Wait for menu to drop down

    ; 2. Press 'C' to select "Collect All and Save"
    ControlSend("c", , "Ableton Live")
    Sleep(200) ; Wait for the file selection dialog box to pop up

    ; 3. Press Enter to confirm the file collection options
    ControlSend("{Enter}", , "Ableton Live")
}
