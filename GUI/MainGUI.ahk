#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ./Components/GUI/Container.ahk

; Variables
windowWidth := titleBarWidth := 1000
windowHeight := 600

titleButtonHeight := 39
titleButtonWidth := 45
titleButtonX := titleBarWidth - titleButtonWidth

TraySetIcon A_ScriptDir "\Assets\logo.ico"  ; Set tray & GUI icon

; Create GUI without standard window border (to allow custom title bar)
global myGui := Gui("-Caption +AlwaysOnTop", "Window Organizer")
myGui.BackColor := "0x555555"

mainView := Container(Dimension(1, 1, windowWidth-2, windowHeight-2), , "0x211D26")
titleBar := Container(Dimension(0, 0, windowWidth-2, titleButtonHeight), mainView, "0x15141B")

;titleBar := myGui.AddText(Format("x0 y0 w{} h39 Background0x2D2B38", titleBarWidth))

; Title bar buttons
xButtonContainer := myGui.AddText(Format("x{} y0 w{} h{} BackgroundTrans", titleButtonX, titleButtonWidth, titleButtonHeight))
xButton := myGui.AddPicture(Format("x{} y0 w{} h{}", titleButtonX, titleButtonWidth, titleButtonHeight), A_ScriptDir "\Assets\close1.png")
xButton.OnEvent("Click", (*) => myGui.Destroy())

expandButtonContainer := myGui.AddText(Format("x{} y0 w{} h{} BackgroundTrans", titleButtonX - titleButtonWidth, titleButtonWidth, titleButtonWidth))
expandButton := myGui.AddPicture(Format("x{} y0 w{} h{}", titleButtonX - titleButtonWidth, titleButtonWidth, titleButtonHeight), A_ScriptDir "\Assets\square1.png")
expandButton.OnEvent("Click", (*) => myGui.Maximize())

minButtonContainer := myGui.AddText(Format("x{} y0 w{} h{} BackgroundTrans", titleButtonX - titleButtonWidth * 2, titleButtonWidth, titleButtonWidth))
minButton := myGui.AddPicture(Format("x{} y0 w{} h{}", titleButtonX - titleButtonWidth * 2, titleButtonWidth, titleButtonHeight), A_ScriptDir "\Assets\minus1.png")
minButton.OnEvent("Click", (*) => myGui.Minimize())

myGui.Show(Format("w{} h{}", windowWidth, windowHeight))

