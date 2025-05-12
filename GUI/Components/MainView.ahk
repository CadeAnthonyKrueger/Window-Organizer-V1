#Requires AutoHotkey v2.0
#Include ../Root.ahk
#Include ../LayoutEngine/Renderer.ahk
#Include ../LayoutEngine/Core/Component.ahk
#Include ../LayoutEngine/Core/Style.ahk
#Include ../LayoutEngine/Core/Cursor.ahk
#Include ../Utils/Path.ahk

class MainView {
    __New(parent) {
        this.parent := parent
        this.styleSheet := Path.Resolve(A_LineFile, "Styles/MainView.ini")
    }

    HandleMouseEnter(el, backgroundColor) {
        Cursor.Set("Help")
        el.ApplyStyle({ backgroundColor: backgroundColor })
    }

    HandleMouseExit(el, backgroundColor) {
        Cursor.Set("Arrow")
        el.ApplyStyle({ backgroundColor: backgroundColor })
    }

    Create() {
        mainView := this.parent.AddChild("MainView", this.styleSheet)

            titleBar := mainView.AddChild("TitleBar", this.styleSheet)

                minimizeButton := titleBar.AddChild("MinimizeButton", this.styleSheet)
                expandButton := titleBar.AddChild("ExpandButton", this.styleSheet)
                closeButton := titleBar.AddChild("CloseButton", this.styleSheet)
                
                    closeButton.On("mouseEnter", (el) => this.HandleMouseEnter(el, "0x000080"))
                    closeButton.On("mouseExit", (el) => this.HandleMouseExit(el, "0xFF0000"))

            DynamicView(mainView).Create()

        return mainView
    }
}