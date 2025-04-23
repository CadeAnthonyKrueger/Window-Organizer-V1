#Requires AutoHotkey v2.0
#SingleInstance

^!c::  ; Ctrl + Alt + C
{
    masterIni := A_ScriptDir "\window_test.ini"

    if !FileExist(masterIni) {
        MsgBox "INI file not found:`n" masterIni
        return
    }

    sectionsText := IniRead(masterIni, , , "")
    sections := StrSplit(sectionsText, "`n")

    for section in sections {
        x        := IniRead(masterIni, section, "x", 0)
        y        := IniRead(masterIni, section, "y", 0)
        width    := IniRead(masterIni, section, "width", 800)
        height   := IniRead(masterIni, section, "height", 600)
        url      := IniRead(masterIni, section, "urlList", "")
        filePath := IniRead(masterIni, section, "filePath", "")

        if !FileExist(filePath) {
            MsgBox "Executable or file not found:`n" filePath
            continue
        }

        urls := StrSplit(url, ",")
        urlArgs := ""  ; Default to empty

        if (url != "") {  ; Only proceed if the URL is not empty
            urlArgs := " --new-window"  ; Insert this before the URLs
            for u in urls
                urlArgs .= Format(' "{}"', Trim(u))
        }

        ; Run the program and get its process ID
        Run Format('"{}"{}', filePath, urlArgs), , , &pid
        Sleep(100)
        ; Get the active window's ID
        WinActivate("ahk_pid " pid)
        hwnd := WinGetID("A")

        if hwnd {
            WinActivate("ahk_id " hwnd)
            Sleep(300)
            WinRestore("ahk_id " hwnd)
            Sleep(300)
            WinMove x, y, width, height, "ahk_id " hwnd
        }
        Sleep(400)
    }
}
