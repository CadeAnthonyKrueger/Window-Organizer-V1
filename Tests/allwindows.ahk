#Requires AutoHotkey v2.0

^!w::  ; Press Ctrl + Alt + W to trigger
{
    winList := WinGetList()  ; Get all window handles
    browserList := ["chrome.exe", "msedge.exe", "firefox.exe", "opera.exe", "brave.exe", "vivaldi.exe"]
    iniFile := A_ScriptDir "\window_info.ini"
    windowIndex := 1

    ; Clear the existing file
    try FileDelete(iniFile)

    for winID in winList {
        if WinExist(winID) {
            winState := WinGetMinMax("ahk_id " winID)
            title := WinGetTitle(winID)
            WinGetPos(&x, &y, &w, &h, winID)
            pid := WinGetPID(winID)
            exePath := ProcessGetPath(pid)
            exeName := exePath ? StrSplit(exePath, "\").Pop() : "Unknown"

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
                    Loop {
                        Send("!d")
                        Sleep(300)
                        Send("^c")
                        Sleep(500)
                        ClipWait(2)
                        clipboardContent := A_Clipboard
                        if (clipboardContent != "EOL") {
                            browserTabs.Push(clipboardContent)
                        } else {
                            break
                        }
                        Send("^{Tab}")
                        Sleep(300)
                    }
                    Sleep(200)
                    Send("^w")
                    Sleep(200)
                    Send("^1")
                } else {
                    Send("^w")
                    Sleep(200)
                    WinActivate(winID)
                    Sleep(200)
                    Send("!d")
                    Send("^l")
                    Sleep(200)
                    Send("^c")
                    Sleep(500)
                    clipboardContent := A_Clipboard
                    if (clipboardContent != "EOL") {
                        browserTabs.Push(clipboardContent)
                    }
                    Sleep(200)
                }
                if winState == -1 {
                    WinMinimize("ahk_id " winID)
                }
            }

            if title && w && h {
                section := "window" windowIndex
                IniWrite title, iniFile, section, "title"
                IniWrite windowIndex, iniFile, section, "index"
                IniWrite winID, iniFile, section, "id"
                IniWrite x, iniFile, section, "x"
                IniWrite y, iniFile, section, "y"
                IniWrite h, iniFile, section, "height"
                IniWrite w, iniFile, section, "width"

                ; Join browser tab URLs into a single line
                urlList := ""
                for i, url in browserTabs {
                    urlList .= (i > 1 ? "," : "") url
                }
                IniWrite urlList, iniFile, section, "urlList"

                IniWrite exePath, iniFile, section, "filePath"

                windowIndex += 1
            }
        }
    }

    MsgBox "INI file created at:`n" iniFile
}
