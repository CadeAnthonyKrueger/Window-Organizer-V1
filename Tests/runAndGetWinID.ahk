#Requires AutoHotkey v2.0
#SingleInstance

^!p::  ; Ctrl + Alt + p
{
    Run("notepad.exe", , , &pid)
    WinWait("ahk_pid " pid)
    hwnd := WinExist("ahk_pid " pid)
    MsgBox("Window ID (HWND): " hwnd)
}
