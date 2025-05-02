#Requires AutoHotkey v2.0
#Include ../Root.ahk
#Include ../LayoutEngine/Renderer.ahk
#Include ../LayoutEngine/Core/Component.ahk
#Include ../LayoutEngine/Core/Style.ahk

class MainView {
    __New() {

    }

    Render() {
        mainView := Component("mainView", root, Style(Dimension(1, 1, windowWidth-2, windowHeight-2), Alignment(display := "flex", direction := "column"), Appearance("0x211D26")))

        titleBar := mainView.AddChild("titleBar", Style(Dimension(0, 0, "100%", "20%"), Alignment(), Appearance("0x15141B")))
        titleBar2 := mainView.AddChild("titleBar2", Style(Dimension(, , "100%", "20%"), Alignment(), Appearance("0x2600ff")))

        block := titleBar2.AddChild("block", Style(Dimension(0, 0, "10%", "100%"), Alignment(), Appearance("0x9dcf29")))

        mainView.Initialize()
    }
}