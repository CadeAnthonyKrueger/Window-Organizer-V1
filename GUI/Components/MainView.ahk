#Requires AutoHotkey v2.0
#Include ../Root.ahk
#Include ../LayoutEngine/Renderer.ahk
#Include ../LayoutEngine/Core/Component.ahk
#Include ../LayoutEngine/Core/Style.ahk
#Include ./Utils/Path.ahk

class MainView {
    __New() {
        this.styleSheet := Path.Resolve(A_LineFile, "Styles/MainView.ini")
    }

    Render() {
        mainView := Component("MainView", this.styleSheet)

            titleBar := mainView.AddChild("TitleBar", this.styleSheet)
            ; titleBar2 := mainView.AddChild("TitleBar2", Style(Dimension(, , "100%", "20%"), Alignment(), Appearance("0x2600ff")))

            ; block := titleBar2.AddChild("Block", Style(Dimension(0, 0, "10%", "100%"), Alignment(), Appearance("0x9dcf29")))

        mainView.Initialize()
    }
}