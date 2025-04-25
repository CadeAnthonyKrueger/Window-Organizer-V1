#Requires AutoHotkey v2.0
#SingleInstance Force

; Variables
windowWidth := titleBarWidth := 800
windowHeight := 500

titleButtonHeight := 39
titleButtonWidth := 45
titleButtonX := titleBarWidth - titleButtonWidth

TraySetIcon A_ScriptDir "\Assets\logo.ico"  ; Set tray & GUI icon

; Create GUI without standard window border (to allow custom title bar)
myGui := Gui("-Caption +Resize +AlwaysOnTop", "Window Organizer")
myGui.BackColor := "0x211D26"

titleBar := myGui.AddText(Format("x0 y0 w{} h39 Background0x2D2B38", titleBarWidth))

; Title bar buttons
xButtonContainer := myGui.AddText(Format("x{} y0 w{} h{} BackgroundTrans", titleButtonX, titleButtonWidth, titleButtonHeight))
xButton := myGui.AddPicture(Format("x{} y0 w{} h{}", titleButtonX, titleButtonWidth, titleButtonHeight), A_ScriptDir "\Assets\close1.png")
xButton.OnEvent("Click", (*) => myGui.Destroy())

expandButtonContainer := myGui.AddText(Format("x{} y0 w{} h{} BackgroundTrans", titleButtonX - titleButtonWidth, titleButtonWidth, titleButtonWidth))
expandButton := myGui.AddPicture(Format("x{} y0 w{} h{}", titleButtonX - titleButtonWidth, titleButtonWidth, titleButtonHeight), A_ScriptDir "\Assets\square1.png")
expandButton.OnEvent("Click", (*) => myGui.Destroy())

minButtonContainer := myGui.AddText(Format("x{} y0 w{} h{} BackgroundTrans", titleButtonX - titleButtonWidth * 2, titleButtonWidth, titleButtonWidth))
minButton := myGui.AddPicture(Format("x{} y0 w{} h{}", titleButtonX - titleButtonWidth * 2, titleButtonWidth, titleButtonHeight), A_ScriptDir "\Assets\minus1.png")
minButton.OnEvent("Click", (*) => myGui.Destroy())

myGui.Show(Format("w{} h{}", windowWidth, windowHeight))

