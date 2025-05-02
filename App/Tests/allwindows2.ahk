#Requires AutoHotkey v2.0

^!w::  ; Press Ctrl + Alt + W to trigger
{
    winList := WinGetList()  ; Get all window handles
    output := ""

    ; List of browser executables
    browserList := ["chrome.exe", "msedge.exe", "firefox.exe", "opera.exe", "brave.exe", "vivaldi.exe"]

    for winID in winList {
        if WinExist(winID) {
            winState := WinGetMinMax("ahk_id " winID)
            title := WinGetTitle(winID)
            WinGetPos(&x, &y, &w, &h, winID)  ; Get window position and size
            pid := WinGetPID(winID)  ; Get Process ID of the window
            exePath := ProcessGetPath(pid)  ; Get the full path of the executable
            
            ; Extract the executable name from the full path
            exeName := exePath ? StrSplit(exePath, "\").Pop() : "Unknown"

            ; Check if the executable is a browser using a loop
            isBrowser := "No"
            for browser in browserList {
                if exeName = browser {
                    isBrowser := "Yes"
                    break
                }
            }
          
            browserTabs := Array()
            if isBrowser == "Yes" {
                WinActivate(winID)
                Sleep(200)
                Send("^t")
                Sleep(300)
                winIDCheck := WinGetID("A")
                Sleep(300)
                if winIDCheck == winID {
                    Send("!d")
                    Sleep(200)
                    Send("EOL")
                    Sleep(200)
                    Send("!d")
                    Sleep(200)
                    Send("^c")
                    Sleep(200)
                    Send("^1")
                    Loop
                    {
                        ; Focus the address bar (Ctrl + L)
                        Send("!d")  
                        Sleep(300)  ; Increased sleep to ensure the address bar gets focus

                        ; Copy the URL (Ctrl + C)
                        Send("^c")  
                        Sleep(500)  ; Wait longer for clipboard to update (500ms)

                        ; Wait for the clipboard to contain content
                        ClipWait(2)  ; Wait for clipboard content to be ready (timeout 2 seconds)
        
                        ; Get the clipboard content as text
                        clipboardContent := A_Clipboard  ; Directly retrieve the clipboard content in AHK v2

                        ; If clipboard content is available, display it
                        if (clipboardContent != "EOL") {
                            browserTabs.Push(clipboardContent)
                        } else {
                            break
                        }

                        ; Optionally, you can add a small delay between iterations (optional)
                        Send("^{Tab}")  ; Send Ctrl + Tab
                        Sleep(300)  ; Sleep for 300ms between loops if needed
                    }
                    Sleep(200)
                    Send("^w")
                    Sleep(200)
                    Send("^1")
                    Sleep(200)
                } else {
                    Send("^w")
                    Sleep(200)

                    WinActivate(winID)
                    Sleep(200)
                    Send("!d")
                    Send("^l")
                    Sleep(200)
                    ; Copy the URL (Ctrl + C)
                    Send("^c")  
                    Sleep(500)  ; Wait longer for clipboard to update (500ms)
                    ; If clipboard content is available, display it
                    if (clipboardContent != "EOL") {
                        browserTabs.Push(clipboardContent)
                    }
                    Sleep(200)
                }
                if winState == -1 {
                    WinMinimize("ahk_id " winID)
                }
            }

            if title && w && h {  ; Ensure window has a title and valid size
                output .= "Title: " title "`n"
                output .= "Executable: " exeName "`n"  ; Display the executable name
                output .= "Browser: " isBrowser "`n"  ; Display whether it's a browser
                output .= "Executable Path: " exePath "`n"
                output .= "X: " x ", Y: " y ", Width: " w ", Height: " h "`n"
                output .= "Tabs: `n"
                Loop browserTabs.Length
                {
                    output .= "`t- " browserTabs[A_Index] "`n"
                }
                output .= "`n"
            }
        }
    }

    MsgBox output ? output : "No visible windows found!"
}
