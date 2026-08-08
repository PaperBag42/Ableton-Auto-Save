#Requires AutoHotkey v2.0

; Set Title Match Mode to 2 (Matches if the string occurs anywhere in the title)
SetTitleMatchMode(2)

AutoSaveEveryInterval(SaveEveryMinutes, IdleSeconds, CollectAll) {
    SetTimer(() => AbletonAutoSave(IdleSeconds, CollectAll), SaveEveryMinutes * 60 * 1000)
}

AbletonAutoSave(IdleSeconds, CollectAll) {
    ; Wait until the user has been completely idle for IdleSeconds
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

    if (!CollectAll) {
        Save()
    } else {
        CollectAllAndSave()
    }
}

Save() {
    Send("^s")
}

CollectAllAndSave() {
    ; 1. Open the File Menu (Alt + F)
    Send("!f")
    Sleep(200) ; Wait for menu to drop down

    ; 2. Press 'C' to select "Collect All and Save"
    Send("c")
    Sleep(200) ; Wait for the file selection dialog box to pop up

    ; 3. Press Enter to confirm the file collection options
    Send("{Enter}")
}
