#Requires AutoHotkey v2.0
#SingleInstance Force

TraySetIcon A_ScriptDir "\logo.ico"  ; Set tray & GUI icon

; Create GUI without standard window border (to allow custom title bar)
myGui := Gui("-Caption +AlwaysOnTop", "Window Organizer")
myGui.BackColor := "0x1d1d1d"  ; Main background color (black)
myGui.SetFont("s10", "Segoe UI")

; --- Custom Title Bar ---
titleBarColor := "0x863535"
titleBar := myGui.AddText("x0 y0 w300 h30 Background" titleBarColor " Center vTitle", "Window Organizer")
titleBar.SetFont("s10 bold", "Segoe UI")

; --- GUI Content ---
label := myGui.AddText("x10 y40", "Enter something:")
editBox := myGui.AddEdit("x10 y60 w200")
button := myGui.AddButton("x10 y90 w200", "Show Message")

myGui.Show("w300 h150")
