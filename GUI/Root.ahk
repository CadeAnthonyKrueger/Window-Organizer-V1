#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ./LayoutEngine/Renderer.ahk
#Include ./LayoutEngine/Core/Window.ahk
#Include ./LayoutEngine/Core/Style.ahk
#Include ./LayoutEngine/Core/Dimension.ahk
#Include ./LayoutEngine/Core/Alignment.ahk
#Include ./LayoutEngine/Core/Appearance.ahk
#Include ./Components/MainView.ahk
#Include ./Utils/Path.ahk

global root := Window("Root", Path.Resolve(A_LineFile, "Root.ini"))

    MainView(root).Render()

root.Initialize()

Renderer.RenderAll()

root.Show()

; mainView := Container( , AlignmentStyles(1, 1, windowWidth-2, windowHeight-2, , , , , "0x211D26", ))
; titleBar := Container(mainView, AlignmentStyles(0, 0, windowWidth-2, titleButtonHeight, , , , , "0x15141B", ))

; mainView := Container( , AlignmentStyles(1, 1, "95%", "95%", , , , , "0x211D26", ))
; titleBar := Container(mainView, AlignmentStyles(0, 0, "95%", titleButtonHeight, , , , , "0x15141B", ))

;titleBar := myGui.AddText(Format("x0 y0 w{} h39 Background0x2D2B38", titleBarWidth))

; Title bar buttons
; xButtonContainer := myGui.AddText(Format("x{} y0 w{} h{} BackgroundTrans", titleButtonX, titleButtonWidth, titleButtonHeight))
; xButton := myGui.AddPicture(Format("x{} y0 w{} h{}", titleButtonX, titleButtonWidth, titleButtonHeight), A_ScriptDir "\Assets\close1_trans.png")
; xButton.OnEvent("Click", (*) => myGui.Destroy())

; expandButtonContainer := myGui.AddText(Format("x{} y0 w{} h{} BackgroundTrans", titleButtonX - titleButtonWidth, titleButtonWidth, titleButtonWidth))
; expandButton := myGui.AddPicture(Format("x{} y0 w{} h{}", titleButtonX - titleButtonWidth, titleButtonWidth, titleButtonHeight), A_ScriptDir "\Assets\square1_trans.png")
; expandButton.OnEvent("Click", (*) => myGui.Maximize())

; minButtonContainer := myGui.AddText(Format("x{} y0 w{} h{} BackgroundTrans", titleButtonX - titleButtonWidth * 2, titleButtonWidth, titleButtonWidth))
; minButton := myGui.AddPicture(Format("x{} y0 w{} h{}", titleButtonX - titleButtonWidth * 2, titleButtonWidth, titleButtonHeight), A_ScriptDir "\Assets\minus1_trans.png")
; minButton.OnEvent("Click", (*) => myGui.Minimize())

; root.Show(Format("w{} h{}", windowWidth, windowHeight))

