#Requires AutoHotkey v2.0

#Include ./EventDispatcher.ahk

class MouseTracker {
    __New(window) {
        this.window := window
        this.textCtrl := ""
        this.windowMouseX := 0
        this.windowMouseY := 0
        SetTimer(this.Track.Bind(this), 30)
    }

    Initialize() {
        this.textCtrl := this.window.GetWindow().AddText("x10 y10 w200", "")
    }

    Track() {
        MouseGetPos(&x, &y)
        this.window.GetWindowCoords(&windowX, &windowY)
        previousX := this.windowMouseX
        previousY := this.windowMouseY
        this.windowMouseX := x - windowX
        this.windowMouseY := y - windowY
        if previousX != this.windowMouseX or previousY != this.windowMouseY {
            this.textCtrl.Value := "Mouse in GUI: x=" this.windowMouseX ", y=" this.windowMouseY
            EventDispatcher.HandleMouseMove(this.windowMouseX, this.windowMouseY)
        }
    }
}