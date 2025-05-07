#Requires AutoHotkey v2.0 

#Include ./Component.ahk

class Window extends Component {
    __New(name, styleSheet) {
        super.__New(name, styleSheet, 0)
        TraySetIcon A_ScriptDir "\Assets\logo.ico"
        CoordMode("Mouse", "Screen")
        this.windowX := 0
        this.windowY := 0
        this.window := Gui("-Caption +AlwaysOnTop", "Window Organizer")
        this.mouseTracker := MouseTracker(this)
    }

    Show() {
        this.mouseTracker.Initialize()
        this.window.BackColor := this.style.appearance.backgroundColor
        this.window.Show(Format("w{} h{}", this.style.dimension.w, this.style.dimension.h))
        this.SetWindowCoords()
    }

    SetWindowCoords() {
        this.window.GetClientPos(&x, &y)
        this.windowX := x
        this.windowY := y
    }

    GetWindowCoords(&windowX, &windowY) {
        windowX := this.windowX
        windowY := this.windowY
    }

    GetWindow() {
        return this.window
    }
}