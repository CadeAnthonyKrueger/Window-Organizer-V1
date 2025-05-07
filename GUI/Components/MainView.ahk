#Requires AutoHotkey v2.0
#Include ../Root.ahk
#Include ../LayoutEngine/Renderer.ahk
#Include ../LayoutEngine/Core/Component.ahk
#Include ../LayoutEngine/Core/Style.ahk
#Include ../Utils/Path.ahk

class MainView {
    __New(parent) {
        this.parent := parent
        this.styleSheet := Path.Resolve(A_LineFile, "Styles/MainView.ini")
    }

    Render() {
        mainView := this.parent.AddChild("MainView", this.styleSheet)

            titleBar := mainView.AddChild("TitleBar", this.styleSheet)

                minimizeButton := titleBar.AddChild("MinimizeButton", this.styleSheet)
                expandButton := titleBar.AddChild("ExpandButton", this.styleSheet)
                closeButton := titleBar.AddChild("CloseButton", this.styleSheet)
    }
}