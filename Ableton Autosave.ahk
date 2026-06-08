#Requires AutoHotkey v2.0
Persistent() ; Keeps the script running in the background

; Set Title Match Mode to 2 (Matches if the string occurs anywhere in the title)
SetTitleMatchMode(2)

; Set a timer to run every 5 minutes (300,000 milliseconds)
SetTimer(CollectAndSaveAbleton, 300000)
; SetTimer(CollectAndSaveAbleton, 3000)

CollectAndSaveAbleton()
{
    ; Wait until the user has been completely idle for 10 seconds (10,000 ms)
    ; This loop pauses the script's save sequence if you are actively working
    while (A_TimeIdle < 10000)
    {
        Sleep(1000) ; Check your activity status again every 1 second
    }

    ; Check if Ableton Live is the active window
    if !WinActive("Ableton Live")
    {
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
