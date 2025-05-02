^!c::  ; Ctrl + Alt + C to run
{
    N := 1  ; Target monitor number

    ; Get the monitor's dimensions
    MonitorGet(N, &Left, &Top, &Right, &Bottom)

    ; File Explorer
    X1 := -8
    Y1 := 0
    W1 := 976
    H1 := 518

    ; VS Code
    X2 := 0
    Y2 := 510
    W2 := 960
    H2 := 510

    ; Chrome
    X3 := 952
    Y3 := 0
    W3 := 976
    H3 := 1028

    ; Open File Explorer window
    explorerPath := "explorer.exe"
    Run explorerPath
    WinWait "ahk_class CabinetWClass"  ; This is the class for File Explorer
    WinActivate "ahk_class CabinetWClass"
    WinMaximize("ahk_class CabinetWClass")
    Sleep 100
    WinRestore("ahk_class CabinetWClass")
    WinMove X1, Y1, W1, H1, "ahk_class CabinetWClass"

    ; Open VS Code window
    Run "C:\Users\Cadea\AppData\Local\Programs\Microsoft VS Code\Code.exe"
    WinWait "ahk_exe Code.exe"
    WinActivate "ahk_exe Code.exe"
    WinMaximize("ahk_exe Code.exe")
    Sleep 100
    WinRestore("ahk_exe Code.exe")
    WinMove X2, Y2, W2, H2, "ahk_exe Code.exe"

    ; Open Chrome window
    Run "C:\Program Files\Google\Chrome\Application\chrome.exe"
    WinWait "ahk_exe chrome.exe"
    WinActivate "ahk_exe chrome.exe"
    WinMaximize("ahk_exe chrome.exe")
    Sleep 100
    WinRestore("ahk_exe chrome.exe")
    WinMove X3, Y3, W3, H3, "ahk_exe chrome.exe"
}
